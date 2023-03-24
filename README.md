# Django Azure Active Directory Sign-In 🔑

[![Django 4.1](https://img.shields.io/badge/Django-4.1.7-green)](https://docs.djangoproject.com/en/4.1/releases/4.1.7/)
[![Python 3.11](https://img.shields.io/badge/Python-3.11.2-green)](https://www.python.org/downloads/release/python-3112/)
[![Umami - GDPR compliant alternative to Google Analytics](https://img.shields.io/badge/analytics-umami-green)](https://analytics.umami.is/share/M19mr5L7jVhHuFnb/jv-conseil.github.io "Umami - GDPR compliant alternative to Google Analytics")
[![License EUPL 1.2](https://img.shields.io/badge/License-EUPL--1.2-blue.svg)](LICENSE)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)
[![CodeQL](https://github.com/JV-conseil-Internet-Consulting/django-azure-active-directory-signin/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/JV-conseil-Internet-Consulting/django-azure-active-directory-signin/actions/workflows/codeql-analysis.yml)
[![codecov](https://codecov.io/gh/JV-conseil-Internet-Consulting/django-azure-active-directory-signin/branch/main/graph/badge.svg?token=WLCTWKAPF6)](https://codecov.io/gh/JV-conseil-Internet-Consulting/django-azure-active-directory-signin)
[![PyPI](https://img.shields.io/pypi/v/django-azure-active-directory-signin?color=green)](https://pypi.org/project/django-azure-active-directory-signin/)
[![Become a sponsor to JV-conseil](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/JV-conseil "Become a sponsor to JV-conseil")
[![Follow JV conseil on StackOverflow](https://img.shields.io/stackexchange/stackoverflow/r/2477854)](https://stackoverflow.com/users/2477854/jv-conseil "Follow JV conseil on StackOverflow")
[![Follow JVconseil on Twitter](https://img.shields.io/twitter/follow/JVconseil.svg?style=social&logo=twitter)](https://twitter.com/JVconseil "Follow JVconseil on Twitter")
[![Follow JVconseil on Mastodon](https://img.shields.io/mastodon/follow/109896584320509054?domain=https%3A%2F%2Ffosstodon.org)](https://fosstodon.org/@JVconseil "Follow JVconseil@fosstodon.org on Mastodon")
[![Follow JV conseil on GitHub](https://img.shields.io/github/followers/JV-conseil?label=JV-conseil&style=social)](https://github.com/JV-conseil "Follow JV-conseil on GitHub")

Sign-in users to your Django Web app with Azure Active Directory.

## Description

`django-azure-active-directory-signin` is a Django app which wraps [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-python)
package to sign in users with Microsoft's Azure Active Directory (OAuth 2.0 and OpenID Connect) in Django projects.

![Sign-in users to your Django Web app with Azure Active Directory](https://user-images.githubusercontent.com/8126807/179853963-7b7048bd-aab5-4eba-8903-7efb8c4ee2aa.svg)

The app includes `login`, `logout` and `callback` authentication views,
a customizable backend to validate, create user and extend user with extra attributes,
a decorator to protect individual views to protect individual views,
and middleware which allows the entire site to require user authentication by default,
with the ability to exempt specified views.

The GitHub repository provides a `demo` Django app to run local tests on `https` protocol thanks to [django-sslserver](https://pypi.org/project/django-sslserver/).

_This project is in no way affiliated with Microsoft Corporation._

## Installation

From PyPi:

```bash
pip install django-azure-active-directory-signin
```

## Configuration

### Azure App Registration

[Register an application](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app). You must have permission to manage applications in Azure Active Directory (Azure AD) on your [Azure account](https://portal.azure.com).

[Add a client secret](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app#add-a-client-secret) in **Certificates & secrets** > **Client secrets** > **New client secret** and note it down.

![Add a client secret](https://docs.microsoft.com/en-us/azure/active-directory/develop/media/quickstart-register-app/portal-05-app-reg-04-credentials.png)

Copy your **client_id**, **tenant_id** and **client_secret** and store them in environment variables (see `.env` folder for sample) or better still in an **Azure Key Vault**.

![Obfuscate your credentials by using environment variables](https://docs.microsoft.com/en-us/azure/active-directory/develop/media/quickstart-register-app/portal-03-app-reg-02.png)

[Add redirect URI](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app#add-a-redirect-uri) like so:

- `https://<your-domain>/azure-signin/callback`
- `https://127.0.0.1:8000/azure-signin/callback`
- `https://localhost:8000/azure-signin/callback`

### Settings

Add the following to your `settings.py`, replacing the variables in braces with the values
from your Azure app:

```py
INSTALLED_APPS += [
    "azure_signin",
]

AZURE_SIGNIN = {
    "CLIENT_ID": os.environ.get("CLIENT_ID"),  # Mandatory
    "CLIENT_SECRET": os.environ.get("CLIENT_SECRET"),  # Mandatory
    "TENANT_ID": os.environ.get("TENANT_ID"),  # Mandatory
    "SAVE_ID_TOKEN_CLAIMS": True,  # Optional, default is False.
    "RENAME_ATTRIBUTES": [
        ("employeeNumber", "employee_id"),
        ("affiliationNumber", "omk2"),
    ],  # Optional
    "REDIRECT_URI": "https://<domain>/azure-signin/callback",  # Optional
    "SCOPES": ["User.Read.All"],  # Optional
    "AUTHORITY": "https://login.microsoftonline.com/" + os.environ.get("TENANT_ID"),  # Optional Or https://login.microsoftonline.com/common if multi-tenant
    "LOGOUT_REDIRECT_URI": "https://<domain>/logout",  # Optional
    "PUBLIC_URLS": ["<public:view_name>",]  # Optional, public views accessible by non-authenticated users
}

AUTHENTICATION_BACKENDS += [
    "azure_signin.backends.AzureSigninBackend",
]

LOGIN_URL = "azure_signin:login"
LOGIN_REDIRECT_URL = "/" # Or any other endpoint
LOGOUT_REDIRECT_URL = LOGIN_REDIRECT_URL
```

### Installed apps

Add the following to your `INSTALLED_APPS`:

```py
INSTALLED_APPS += [
    "azure_signin",
]
```

### Authentication backend

Configure the authentication backend:

```py
AUTHENTICATION_BACKENDS += [
    "azure_signin.backends.AzureSigninBackend",
]
```

### URLs

Include the app's URLs in your `urlpatterns`:

```py
from django.urls import path, include

urlpatterns += [
    path("azure-signin/", include("azure_signin.urls", namespace="azure_signin")),
]
```

## Usage

### AbstractUser

Add extra attributes to users with `AZURE_SIGNIN["RENAME_ATTRIBUTES"]`
and Django `django.contrib.auth.models.AbstractUser`.

```py
from django.contrib.auth.models import AbstractUser
from django.db import models


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
```

### Backend

Backend can be subclassed to customize validation rules for user.

```py
import logging

from azure_signin.backends import AzureSigninBackend

logger = logging.getLogger(__name__)

class CustomAzureSigninBackend(AzureSigninBackend):
    "Subclass AzureSigninBackend to customize validation rules for user."

    def is_valid_user(self, user: dict, *args, **kwargs) -> bool:
        "is_valid_user"
        output = super().is_valid_user(user, *args, **kwargs)
        try:
            "run extra checks here..."
            pass
        except Exception as e:
            logger.exception(e)
        logger.debug("is_valid_user: %s", output)
        return output
```

### Decorator

To make user authentication a requirement for accessing an individual view, decorate the
view like so:

```py
from azure_signin.decorators import azure_signin_required
from django.shortcuts import HttpResponse

@azure_signin_required
def protected_view(request):
    return HttpResponse("A view protected by the decorator")
```

### Middleware

If you want to protect your entire site by default, you can use the middleware by adding the
following to your `settings.py`:

```python
MIDDLEWARE += [
    "azure_signin.middleware.AzureSigninMiddleware",
]
```

Make sure you add the middleware after Django's `session` and `authentication` middlewares so
that the request includes the session and user objects. Public URLs which need to be accessed by
non-authenticated users should be specified in the `settings.AZURE_SIGNIN["PUBLIC_URLS"]`, as
shown above.

### VS Code Tasks

The GitHub repository provides commands `Install`, `Launch` and `Tests` accessible through
`Command Palette` (press `Cmd+Shift+P`) then `>Tasks: Run Tasks`.

![VS Code Tasks](https://user-images.githubusercontent.com/8126807/179760209-b600877d-ac74-4fe1-b042-32ed26fd7430.png)
![The app includes `Install`, `Launch` and `Tests` commands accessible through `Command Palette > Tasks: Run Tasks` (press `Cmd+Shift+P`)](https://user-images.githubusercontent.com/8126807/179760201-7203836c-fdb9-42d9-84f7-656b57a6721a.png)

All bash scripts are stored in `.bash` folder.

The virtual environment is propelled by [poetry](https://python-poetry.org) which can be installed with Homebrew `brew install poetry`.

## Credits

This app is inspired by and builds on functionality in
<https://github.com/AgileTek/django-azure-auth>, with both feature
improvements, code coverage and extended documentation.

## Readings 📚

- [Quickstart: Add sign-in with Microsoft to a web app](https://docs.microsoft.com/en-us/azure/active-directory/develop/web-app-quickstart?pivots=devlang-python) (docs.microsoft.com)
- [Microsoft Graph REST API v1.0](https://docs.microsoft.com/en-us/graph/api/user-get?view=graph-rest-1.0&tabs=http#permissions) (docs.microsoft.com)
- [Enable your Python Django web app to sign in users to your Azure Active Directory](https://github.com/Azure-Samples/ms-identity-python-django-tutorial/tree/main/1-Authentication/sign-in) tenant with the Microsoft identity platform (github.com)

## Sponsorship

If this project helps you, you can offer me a cup of coffee ☕️ :-)

[![Become a sponsor to JV-conseil](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/JV-conseil)
