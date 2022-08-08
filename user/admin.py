from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.utils.translation import gettext_lazy as _

from .models import ExtendedUser


class ExtendedUserAdmin(UserAdmin):
    list_display = (
        "id",
        "last_name",
        "first_name",
        "email",
        "username",
        "hcm",
        "omk2",
        "employee_id",
        "is_superuser",
    )
    default_fieldsets = UserAdmin.fieldsets
    fieldsets = (
        default_fieldsets[:2]
        + ((_("Azure SignIn"), {"fields": ("id_token_claims",)}),)
        + default_fieldsets[2:]
    )


admin.site.register(ExtendedUser, ExtendedUserAdmin)
