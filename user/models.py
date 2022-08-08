import logging

from django.contrib.auth.models import AbstractUser
from django.db import models

logger = logging.getLogger(__name__)


class ExtendedUser(AbstractUser):
    """
    Extend user with extra attributes set in `AZURE_SIGNIN["RENAME_ATTRIBUTES"]`
    """

    email = models.EmailField(unique=True, db_index=True)
    employee_id = models.IntegerField(
        null=True, default=None, unique=True, blank=True, db_index=True
    )
    omk2 = models.CharField(max_length=5, null=True, default=None, db_index=True)
    hcm = models.CharField(max_length=7, null=True, default=None, db_index=True)
    id_token_claims = models.TextField(default="", blank=True)

    def save(self, *args, **kwargs):
        "save"
        try:
            if not isinstance(self.id_token_claims, str):
                self.id_token_claims = str(self.id_token_claims)
        except Exception as e:
            logger.exception(e)
        return super().save()
