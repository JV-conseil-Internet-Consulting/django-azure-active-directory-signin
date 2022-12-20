#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV conseil – Internet Consulting
# credits       : JV-conseil
# licence       : BSD 3-Clause License.
# copyright     : Copyright (c) 2022, JV conseil – Internet Consulting,
#                 All rights reserved.
#======================================================================


# shellcheck disable=SC1091
source ".bash/osx/bash_alias.sh"


cd "$FOLDER_PATH" || exit

# Poetry install

echo -e "\n\e[0;35mChecking if poetry is installed or install it with Homebrew...\e[0;0m"

brew ls --versions poetry || brew install poetry

echo -e "\n\e[0;35mDeleting any existing 'poetry.lock' file...\e[0;0m"

find . -type f -name "poetry.lock" -print -delete

poetry env use "${PYTHONPATH}"
poetry check
poetry install
poetry update
poetry show --tree

echo -e "\n\e[0;35mExporting requirements.txt files...\e[0;0m"

poetry export --without-hashes -f requirements.txt --output requirements.txt
poetry export --dev --without-hashes -f requirements.txt --output requirements-full.txt

# How do I trim leading and trailing whitespace from each line of some output?
# https://unix.stackexchange.com/a/102229/473393

echo "Triming requirements-dev.txt..."

comm -3 requirements.txt requirements-full.txt | awk '{$1=$1};1' > requirements-dev.txt
rm -rf requirements-full.txt

echo -e "\n\e[0;35mInitiating Django...\e[0;0m"

echo -e "\nDeleting any existing 'db.sqlite3' and migrations...\n"

find . -type f -name "db.sqlite3" -print -delete
find . -type f -path "*/migrations/*" -name "0*.py" -print -delete

echo -e "\nRunning migrations...\n"

poetry run python manage.py makemigrations
poetry run python manage.py migrate

echo -e "\n\e[0;35mCreating a superuser...\e[0;0m"
__username="superuser@django-azure-active-directory-signin.io"
__password=$(python3 -c "import secrets; result = ''.join(secrets.choice('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789') for i in range(15)); print(result)")
echo "Username: ${__username}"
echo "Password: ${__password}"

# poetry run python manage.py createsuperuser --username admin@nomail.com --email admin@nomail.com

echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('${__username}', '${__username}', '${__password}');" | poetry run python manage.py shell && echo -e "\n\e[0;33mDone!\nYou will be able to test superuser access to the admin panel by visiting https://127.0.0.1:8000/admin/\e[0;0m"


# Pipenv install


# echo
# read -r -n 1 -p "Do you want to set a Pipenv environment? [y/N] "
# if [[ $REPLY =~ ^[Yy]$ ]]
# then
#     brew ls --versions pipenv || brew install pipenv

#     find . -type f -name "Pipfile*" -print -delete
#     pipenv --rm
#     sudo pipenv --clear  # clear cache
#     pipenv install --verbose -d -r ./requirements-dev.txt
#     pipenv install --verbose -r ./requirements.txt
# fi
