from azure_signin.views import (
    azure_signin_callback,
    azure_signin_login,
    azure_signin_logout,
    azure_signin_redirect,
)

try:
    from core.forms import GenericAuthenticationForm
except Exception:
    from django.contrib.auth.forms import (
        AuthenticationForm as GenericAuthenticationForm,
    )
from django.conf import settings
from django.contrib.auth import views as auth_views
from django.urls import include, path

from .configuration import AzureSigninConfig

app_name = "azure_signin"
urlpatterns = [
    path("login", azure_signin_login, name="login"),
    path("logout", azure_signin_logout, name="logout"),
    path("callback", azure_signin_callback, name="callback"),
    path("redirect", azure_signin_redirect, name="redirect"),
]


azure_signin_urlpatterns = [
    path("azure-signin/", include("azure_signin.urls", namespace="azure_signin")),
]


if "TODO" in AzureSigninConfig.TENANT_ID:

    azure_signin_urlpatterns += [
        path(
            "login/",
            auth_views.LoginView.as_view(
                form_class=GenericAuthenticationForm,
                template_name="registration/login.html",
                extra_context={"site": settings.SITE},
            ),
            name="sso_login",
        ),
        path(
            "logout/",
            auth_views.LogoutView.as_view(template_name="registration/logged_out.html"),
            name="sso_logout",
        ),
    ]

else:

    azure_signin_urlpatterns += [
        path("accounts/login/", azure_signin_login, name="sso_login"),
        path("accounts/logout/", azure_signin_logout, name="sso_logout"),
    ]
