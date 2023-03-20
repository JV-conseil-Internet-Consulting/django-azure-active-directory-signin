import logging
from functools import cached_property, lru_cache
from types import SimpleNamespace

from django.conf import settings

from .utils import logger_debug

logger = logging.getLogger(__name__)


class _AzureSigninConfig:
    "TODO: Handle if user has put incorrect details in settings"

    def __init__(self, config={}, namespace="azure_signin:callback", *args, **kwargs):
        self._config = config
        self._namespace = namespace

    @cached_property
    def config(self, *args, **kwargs) -> dict:
        "config"
        output = {}
        try:
            output = self._config.copy()
            output["MS_GRAPH_API"] = "https://graph.microsoft.com/v1.0/me"
            output["RENAME_ATTRIBUTES"] = output.pop("RENAME_ATTRIBUTES", [])
            output["RENAME_ATTRIBUTES"] += [
                ("family_name", "last_name"),
                ("given_name", "first_name"),
                ("givenName", "first_name"),
                ("mail", "email"),
                ("preferred_username", "username"),
                ("surname", "last_name"),
                ("upn", "username"),
            ]
            output["RENAME_ATTRIBUTES"] = list(set(output["RENAME_ATTRIBUTES"]))
            output["TENANT_ID"] = output.pop("TENANT_ID", "common")
            output["AUTHORITY"] = output.pop(
                "AUTHORITY", "https://login.microsoftonline.com/" + output["TENANT_ID"]
            )
            output["LOGOUT_URI"] = output["AUTHORITY"] + "/oauth2/v2.0/logout"
            output["PUBLIC_URLS"] = [
                "azure_signin:login",
                "azure_signin:logout",
                "azure_signin:callback",
            ] + output.pop("PUBLIC_URLS", [])
            output["PUBLIC_URLS"] = list(set(output["PUBLIC_URLS"]))
            output["REDIRECT_URI"] = output.pop("REDIRECT_URI", self._namespace)
            output["LOGOUT_REDIRECT_URI"] = output.pop(
                "LOGOUT_REDIRECT_URI", settings.LOGOUT_REDIRECT_URL
            )
            output["MESSAGE_SUCCESS"] = output.pop(
                "MESSAGE_SUCCESS",
                "Welcome <b>{first_name}</b> &#128075; you now are logged in.",
            )
            output["MESSAGE_ERROR"] = output.pop(
                "MESSAGE_ERROR", "An error occured, we cannot sign you in."
            )
            output["SAVE_ID_TOKEN_CLAIMS"] = output.pop("SAVE_ID_TOKEN_CLAIMS", False)
            output["SCOPES"] = output.pop("SCOPES", ["User.Read"])
        except Exception as e:
            logger.exception(e)
        # logger_debug("config", output)
        return output

    @lru_cache
    def parse_settings(self, *args, **kwargs):
        "parse_settings"
        output = None
        try:
            self.sanity_check_configs()
            config = SimpleNamespace(**self.config)

            output = config
        except Exception as e:
            logger.exception(e)
        # logger.debug("parse_settings: %s", output)
        return output

    @lru_cache
    def sanity_check_configs(self) -> None:
        required = ("AUTHORITY", "CLIENT_ID", "CLIENT_SECRET", "TENANT_ID")
        # required = ("AUTHORITY", "CLIENT_ID", "TENANT_ID")
        for req in required:
            assert self.config.get(req), f"{req} must be non-empty string"

        is_string = required + (
            "LOGOUT_REDIRECT_URI",
            "LOGOUT_URI",
            "MESSAGE_ERROR",
            "MESSAGE_SUCCESS",
            "REDIRECT_URI",
        )
        for req in is_string:
            req_ = self.config.get(req)
            if not req_:
                continue
            assert str(req_), f"{req} must be non-empty string"

        is_list = ("PUBLIC_URI", "RENAME_ATTRIBUTES", "SCOPES")
        for req in is_list:
            req_ = self.config.get(req)
            if not req_:
                continue
            assert list(req_), f"{req} must be non-empty list"

        is_bool = ("SAVE_ID_TOKEN_CLAIMS",)
        for req in is_bool:
            req_ = self.config.get(req)
            if not req_:
                continue
            assert isinstance(req_, bool), f"{req} must be bool"


AzureSigninConfig = _AzureSigninConfig(config=settings.AZURE_SIGNIN).parse_settings()
