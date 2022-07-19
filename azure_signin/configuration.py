from functools import lru_cache
import logging
from types import SimpleNamespace

from django.conf import settings

from .utils import logger_debug

logger = logging.getLogger(__name__)


class _AzureSigninConfig:
    "TODO: Handle if user has put incorrect details in settings"

    def __init__(self, config={}, namespace="azure_signin:callback", *args, **kwargs):
        config["USER_IDENTIFIER_FIELD"] = config.get(
            "USER_IDENTIFIER_FIELD", "username"
        )
        config["MS_GRAPH_API"] = "https://graph.microsoft.com/v1.0/me"
        config["RENAME_ATTRIBUTES"] = [
            ("family_name", "last_name"),
            ("given_name", "first_name"),
            ("givenName", "first_name"),
            ("mail", "email"),
            ("mail", "username"),
            # ("preferred_username", "username"),
            ("surname", "last_name"),
            # ("upn", "username"),
        ] + config.get("RENAME_ATTRIBUTES", [])
        config["TENANT_ID"] = config.get("TENANT_ID", "common")
        config["AUTHORITY"] = config.get(
            "AUTHORITY", "https://login.microsoftonline.com/" + config["TENANT_ID"]
        )
        config["LOGOUT_URI"] = config["AUTHORITY"] + "/oauth2/v2.0/logout"
        config["PUBLIC_URLS"] = [
            "azure_signin:login",
            "azure_signin:logout",
            "azure_signin:callback",
        ] + config.get("PUBLIC_URLS", [])
        config["REDIRECT_URI"] = config.get("REDIRECT_URI", namespace)
        config["LOGOUT_REDIRECT_URI"] = config.get(
            "LOGOUT_REDIRECT_URI", settings.LOGOUT_REDIRECT_URL
        )
        for list_key in ["SCOPES"]:
            config[list_key] = config.get(list_key, [])
        self.config = config
        # logger_debug("config", config)

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
        for req in required:
            assert self.config.get(req), f"{req} must be non-empty string"

        is_string = required + (
            "LOGOUT_REDIRECT_URI",
            "LOGOUT_URI",
            "REDIRECT_URI",
            "USER_IDENTIFIER_FIELD",
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

        user_identifier_field_choices = ["username", "email"]
        assert (
            self.config.get("USER_IDENTIFIER_FIELD") in user_identifier_field_choices
        ), f"USER_IDENTIFIER_FIELD not in {str(user_identifier_field_choices)}"


AzureSigninConfig = _AzureSigninConfig(config=settings.AZURE_SIGNIN).parse_settings()
