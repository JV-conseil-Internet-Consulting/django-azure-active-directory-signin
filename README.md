# Django Azure Active Directory Sign-In

[![Django 4.0.6](https://img.shields.io/badge/Django-4.0.6-green)](https://docs.djangoproject.com/en/4.0/releases/4.0.6/)
[![Donate with PayPal](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/donate/?hosted_button_id=P3DGL6EANDY96)
[![License BSD 3-Clause](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](LICENSE)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)
![Build](https://github.com/JV-conseil-Internet-Consulting/django-azure-active-directory-signin/actions/workflows/push-actions.yml/badge.svg)
[![Follow JV conseil – Internet Consulting on Twitter](https://img.shields.io/twitter/follow/JVconseil.svg?style=social&logo=twitter)](https://twitter.com/JVconseil)

Sign-in users to your Django Web app with Azure Active Directory.

## Description

![Sign-in users to your Django Web app with Azure Active Directory](https://docs.microsoft.com/en-us/azure/active-directory/develop/media/quickstart-v2-python-webapp/python-quickstart.svg)

`django-azure-active-directory-signin` is a Django app which wraps the great [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-python)
package to enable authentication against Microsoft's Azure Active Directory in Django projects.

The app includes `login`, `logout` and `callback` authentication views, a decorator
to protect individual views, and middleware which allows the entire site to require user
authentication by default, with the ability to exempt specified views.

This project is in no way affiliated with Microsoft.

## Installation

From PyPi:

```bash
pip install django-azure-active-directory-signin
```

## Configuration

### Azure App Registration setup

- Register an app at <https://portal.azure.com/>.
- Add a client secret and note it down.
- Add a Redirect URI of the format `https://<domain>/azure-signin/callback`.

### Settings

Add the following to your `settings.py`, replacing the variables in braces with the values
from your Azure app:

```py
INSTALLED_APPS += [
    "azure_signin",
]

AZURE_SIGNIN = {
    "CLIENT_ID": os.environ.get("CLIENT_ID"),
    "CLIENT_SECRET": os.environ.get("CLIENT_SECRET"),
    "TENANT_ID": os.environ.get("TENANT_ID"),
    "RENAME_ATTRIBUTES": [
        ("employeeNumber", "employee_id"),
        ("affiliationNumber", "omk2"),
    ],
    "REDIRECT_URI": "https://<domain>/azure_signin/callback",  # Optional
    "SCOPES": ["User.Read.All"],  # Optional
    "AUTHORITY": "https://login.microsoftonline.com/<tenant id>",  # Optional Or https://login.microsoftonline.com/common if multi-tenant
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

#### Note: You should obfuscate the credentials by using environment variables

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

### Decorator

To make user authentication a requirement for accessing an individual view, decorate the
view like so:

```python
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

## Planned development

- Groups management

## Credits

This app is heavily inspired by and builds on functionality in
<https://github.com/shubhamdipt/django-microsoft-authentication>, with both feature
improvements and code assurance through testing.

Credit also to:

- <https://github.com/Azure-Samples/ms-identity-python-webapp>
- <https://github.com/AzMoo/django-okta-auth>
