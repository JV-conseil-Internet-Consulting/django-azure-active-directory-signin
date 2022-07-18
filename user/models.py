from django.contrib.auth.models import AbstractUser
from django.db import models


class CustomUser(AbstractUser):
    email = models.EmailField(unique=True, db_index=True)
    employee_id = models.IntegerField(
        null=True, default=None, unique=True, blank=True, db_index=True
    )
    omk2 = models.CharField(max_length=5, null=True, default=None, db_index=True)
