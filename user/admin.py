from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from .models import ExtendedUser


class ExtendedUserAdmin(UserAdmin):
    list_display = (
        "last_name",
        "first_name",
        "email",
        "username",
        "hcm",
        "omk2",
        "employee_id",
        "is_superuser",
    )


admin.site.register(ExtendedUser, ExtendedUserAdmin)
