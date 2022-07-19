"""demo URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""

import os

from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import include, path
from ms_identity_web.django.msal_views_and_urls import MsalViews

from . import views

msal_urls = MsalViews(settings.MS_IDENTITY_WEB).url_patterns()

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", views.index, name="index"),
    path("sign-in-status", views.index, name="status"),
    path("token-details", views.token_details, name="token_details"),
]

# Enable your Python Django web app to sign in users to your Azure Active Directory tenant with the Microsoft identity platform
# https://github.com/Azure-Samples/ms-identity-python-django-tutorial/tree/main/1-Authentication/sign-in


urlpatterns += [
    path(f"{settings.AAD_CONFIG.django.auth_endpoints.prefix}/", include(msal_urls)),
    *static(settings.STATIC_URL, document_root=settings.STATIC_ROOT),
]

# Django Azure AD Sign-In
# https://pypi.org/project/django-azure-active-directory-signin/


azure_signin_redirect_uri = [
    # "azad-auth",
    # "azad-oauth2",
    # "azure_signin",
    # "azure-ad-auth",
    "azure-signin",
    # "oauth2",
]


"Azure App Registration > Redirect URI"

print("Azure App Registration: " + os.environ.get("AZAD_APP_REGISTRATION_NAME", ""))
print("Azure App Registration > Redirect URI")
print("-------------------------------------")
for domain in settings.ALLOWED_HOSTS:
    if domain in ["127.0.0.1", "localhost"]:
        domain += ":8000"
    for path_ in azure_signin_redirect_uri:
        for redirect_ in ["callback", "redirect"]:
            print(f"- https://{domain}/{path_}/{redirect_}")
print()

urlpatterns += [
    path("azure-auth/", include("azure_signin.urls", namespace="azure_signin")),
    # path("azure-signin/", include("azure_signin.urls", namespace="azure_signin")),
]
