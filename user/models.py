from django.contrib.auth.models import AbstractUser
from django.db import models


class ExtendedUser(AbstractUser):
    """
    Extend user with extra attributes set in `AZURE_SIGNIN['RENAME_ATTRIBUTES']`
    """

    email = models.EmailField(unique=True, db_index=True)
    employee_id = models.IntegerField(
        null=True, default=None, unique=True, blank=True, db_index=True
    )
    omk2 = models.CharField(max_length=5, null=True, default=None, db_index=True)
    hcm = models.CharField(max_length=7, null=True, default=None, db_index=True)
