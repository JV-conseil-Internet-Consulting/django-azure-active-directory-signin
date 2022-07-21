import logging

from django.contrib.auth import get_user_model
from django.contrib.auth.backends import ModelBackend
from django.db.models import Q

from .handlers import AzureSigninHandler
from .configuration import _AzureSigninConfig, AzureSigninConfig

UserModel = get_user_model()

logger = logging.getLogger(__name__)


class AzureSigninBackend(ModelBackend):
    """
    Authenticates against settings.AUTH_USER_MODEL.
    """

    def is_valid_user(self, user: dict, *args, **kwargs) -> bool:
        "is_valid_user"
        output = False
        required_attributes = [
            good
            for bad, good in _AzureSigninConfig().config.get("RENAME_ATTRIBUTES", [])
        ]
        try:
            all_required = all(user.get(a) for a in required_attributes)
            assert all_required, "At least one required attribute is missing."
            output = all_required

            all_string = all(isinstance(user.get(a), str) for a in required_attributes)
            assert all_string, "At least one required attribute is not a string."
            output = all_string

        except Exception as e:
            logger.exception(e)
        logger.debug("is_valid_user: %s", output)
        return output

    @staticmethod
    def get_user_from_user_model(user: dict):
        """Dual search on both username & email

        Canonical approach:

        `UserModel._default_manager.get_by_natural_key(user.get("username", "NoUsername")`
        """
        return UserModel._default_manager.get(
            Q(email=user.get("email", "NoEmail"))
            | Q(username=user.get("username", "NoUsername"))
        )

    @staticmethod
    def update_user_attributes(user: object, attributes=dict, *args, **kwargs):
        "update_user_attributes"
        try:
            for key, value in attributes.items():
                if not value:
                    continue
                setattr(user, key, value)
            user.save()
        except Exception as e:
            logger.exception(e)

    def authenticate(self, request, token={}, *args, **kwargs):
        """
        Helper method to authenticate the user. Gets the Azure user from the
        Microsoft Graph endpoint and gets/creates the associated Django user.

        :param token: MSAL auth token dictionary
        :return: Django user instance
        """
        output = None
        try:
            if not token:
                return output

            user_ = AzureSigninHandler(request).user_django_mapping(token)

            if not user_:
                return output

            if not self.is_valid_user(user_):
                return output

            try:
                user = self.get_user_from_user_model(user_)
                self.update_user_attributes(user, user_)
            except UserModel.DoesNotExist:
                user = UserModel._default_manager.create_user(**user_)
                user.save()

            if not self.user_can_authenticate(user):
                return output

            output = user

        except Exception as e:
            logger.exception(e)
        logger.debug("authenticate: %s", output)
        return output
