import logging
from http import HTTPStatus

import msal
import requests

from django.urls import reverse

from .configuration import AzureSigninConfig
from .exceptions import (
    InvalidAuthenticationToken,
    RenameAttributesValueError,
    TokenError,
)
from .utils import logger_debug

logger = logging.getLogger(__name__)


class AzureSigninHandler:
    """
    Class to interface with `msal` package and execute authentication process.
    """

    def __init__(self, request=None):
        """

        :param request: HttpRequest
        """
        self.request = request
        self.build_uri = self.request.build_absolute_uri
        self.redirect_uri = (
            self.build_uri(reverse(AzureSigninConfig.REDIRECT_URI))
            if not AzureSigninConfig.REDIRECT_URI.startswith("http")
            else AzureSigninConfig.REDIRECT_URI
        )
        self.logout_redirect_uri = (
            self.build_uri(AzureSigninConfig.LOGOUT_REDIRECT_URI)
            if not AzureSigninConfig.LOGOUT_REDIRECT_URI.startswith("http")
            else AzureSigninConfig.LOGOUT_REDIRECT_URI
        )
        self.auth_flow_session_key = "auth_flow"
        self._cache = msal.SerializableTokenCache()
        self._msal_app = None

    def get_auth_uri(self) -> str:
        """
        Requests the auth flow dictionary and stores it on the session to be
        queried later in the auth process.

        :return: Authentication redirect URI
        """
        output = ""
        try:
            flow = self.msal_app.initiate_auth_code_flow(
                scopes=AzureSigninConfig.SCOPES,
                redirect_uri=self.redirect_uri,
            )
            auth_uri = flow.get("auth_uri")
            if auth_uri:
                self.request.session[self.auth_flow_session_key] = flow
                output = auth_uri
        except Exception as e:
            logger.exception(e)
        logger.debug("get_auth_uri: %s", output)
        return output

    def get_token_from_flow(self) -> dict:
        """
        Acquires the token from the auth flow on the session and the content of
        the redirect request from Active Directory.

        :return: Token result containing `access_token`/`id_token` and other
        claims, depending on scopes used
        """
        output = {}
        try:
            flow = self.request.session.pop(self.auth_flow_session_key, {})
            token_result = self.msal_app.acquire_token_by_auth_code_flow(
                auth_code_flow=flow, auth_response=self.request.GET
            )

            token_error = token_result.get("error")
            if token_error:
                raise TokenError(token_result)

            self._save_cache()
            self.request.session["id_token_claims"] = token_result["id_token_claims"]
            output = token_result
        except Exception as e:
            logger.exception(e)
        logger_debug("get_token_from_flow", output, logger)
        return output

    def get_token_from_cache(self):
        accounts = self.msal_app.get_accounts()
        if accounts:  # pragma: no branch
            # Will return `None` if CCA cannot retrieve or generate new token
            token_result = self.msal_app.acquire_token_silent(
                scopes=AzureSigninConfig.SCOPES, account=accounts[0]
            )
            self._save_cache()
            return token_result

    def get_logout_uri(self) -> str:
        """
        Forms the URI to log the user out in the Active Directory app and
        redirect to the webapp logout page.

        :return: Active Directory app logout URI
        """
        output = AzureSigninConfig.LOGOUT_URI
        try:
            if self.logout_redirect_uri:
                output += "?post_logout_redirect_uri=" + self.logout_redirect_uri
        except Exception as e:
            logger.exception(e)
        logger.debug("get_logout_uri: %s", output)
        return output

    @property
    def msal_app(self, *args, **kwargs) -> None:
        "msal_app"
        output = None
        try:
            if not self._msal_app:
                self._msal_app = msal.ConfidentialClientApplication(
                    client_id=AzureSigninConfig.CLIENT_ID,
                    client_credential=AzureSigninConfig.CLIENT_SECRET,
                    authority=AzureSigninConfig.AUTHORITY,
                    token_cache=self.cache,
                    # validate_authority="https://login.microsoftonline.com/" in AzureSigninConfig.AUTHORITY,
                    validate_authority=AzureSigninConfig.AUTHORITY.startswith(
                        "https://login.microsoftonline.com/"
                    ),
                )
            output = self._msal_app
        except Exception as e:
            logger.exception(e)
        logger.debug("msal_app: %s", output)
        return output

    @property
    def cache(self):
        token_cache = self.request.session.get("token_cache")
        if token_cache:
            self._cache.deserialize(token_cache)
        return self._cache

    def _save_cache(self):
        if self.cache.has_state_changed:
            self.request.session["token_cache"] = self.cache.serialize()

    def _get_microsoft_graph_user(self, token: dict, *args, **kwargs) -> dict:
        "_get_microsoft_graph_user"
        output = {}
        try:
            access_token = token.get("access_token")
            if not access_token:
                return output

            response = requests.get(
                AzureSigninConfig.MS_GRAPH_API,
                headers={"Authorization": f"Bearer {access_token}"},
            )
            if response.ok:
                output = response.json()
            elif response.status_code == HTTPStatus.UNAUTHORIZED:
                raise InvalidAuthenticationToken(response.json()["error"])

        except Exception as e:
            logger.exception(e)
        logger_debug("_get_microsoft_graph_user", output, logger)
        return output

    def _rename_attributes(self, dct: dict, *args, **kwargs) -> dict:
        "_rename_attributes"
        output = dct
        try:
            for bad, good in AzureSigninConfig.RENAME_ATTRIBUTES:
                value = dct.get(bad)
                if not value:
                    continue

                good_ = dct.get(good)
                if good_ and good_ != value:
                    raise RenameAttributesValueError(
                        f"`{good}` key already exists with value `{good_}`, new value `{value}` is different."
                    )

                "email enforce lower case"
                if good == "email":
                    value = value.lower()
                dct[good] = value

            output = dct
        except Exception as e:
            logger.exception(e)
        logger_debug("_rename_attributes", output, logger)
        return output

    def _combine_user_details(self, token: dict, *args, **kwargs) -> dict:
        "_combine_user_details"
        output = {}
        try:
            infos = {}
            infos.update(token.get("id_token_claims"))
            infos.update(self._get_microsoft_graph_user(token))
            infos = self._rename_attributes(infos)
            if infos:
                output = infos
        except Exception as e:
            logger.exception(e)
        logger_debug("_combine_user_details", output, logger)
        return output

    def user_django_mapping(self, token: dict, *args, **kwargs) -> dict:
        "generic_function"
        output = {}
        try:
            user = self._combine_user_details(token)
            if user:
                output = {
                    key: value
                    for key, value in user.items()
                    if value
                    and key
                    in [good for bad, good in AzureSigninConfig.RENAME_ATTRIBUTES]
                }

                if not output.get("username"):
                    output["username"] = user.get("email", "")

                if AzureSigninConfig.SAVE_ID_TOKEN_CLAIMS:
                    user.pop("@odata.context", "")
                    output["id_token_claims"] = user
        except Exception as e:
            logger.exception(e)
        logger_debug("user_django_mapping", output, logger)
        return output
