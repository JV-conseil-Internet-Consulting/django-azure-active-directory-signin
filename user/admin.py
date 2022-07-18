from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from .models import CustomUser


class CustomUserAdmin(UserAdmin):
    list_display = (
        "username",
        "email",
        "first_name",
        "last_name",
        "omk2",
        "employee_id",
        "is_superuser",
    )


admin.site.register(CustomUser, CustomUserAdmin)
