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
source ".bash/bash_alias.sh"


cd "$FOLDER_PATH" || exit

# Poetry install

echo "Checking if poetry is installed or install it with Homebrew..."

brew ls --versions poetry || brew install poetry

echo "Deleting any existing 'poetry.lock' file..."

find . -type f -name "poetry.lock" -print -delete

poetry check
poetry install
poetry update
poetry show --tree

echo "Exporting requirements.txt files..."

poetry export --without-hashes -f requirements.txt --output requirements.txt
poetry export --dev --without-hashes -f requirements.txt --output requirements-full.txt

# How do I trim leading and trailing whitespace from each line of some output?
# https://unix.stackexchange.com/a/102229/473393

echo "Triming requirements-dev.txt..."

comm -3 requirements.txt requirements-full.txt | awk '{$1=$1};1' > requirements-dev.txt
rm requirements-full.txt &> /dev/null

echo
read -r -N 1 -p "Do you want to initiate Django? [y/N] "
echo
if [[ $REPLY =~ ^[y]$ ]]
then
    echo "Deleting any existing 'db.sqlite3' and migrations..."

    find . -type f -name "db.sqlite3" -print -delete
    find . -type f -path "*/migrations/*" -name "0*.py" -print -delete

    echo "Running migrations..."

    poetry run python manage.py makemigrations
    poetry run python manage.py migrate

    echo "Creating a superuser..."

    poetry run python manage.py createsuperuser
fi


# Pipenv install

echo
read -r -N 1 -p "Do you want to set a Pipenv environment? [y/N] "
echo
if [[ $REPLY =~ ^[y]$ ]]
then
    brew ls --versions pipenv || brew install pipenv

    find . -type f -name "Pipfile*" -print -delete
    pipenv --rm
    sudo pipenv --clear  # clear cache
    pipenv install --verbose -d -r ./requirements-dev.txt
    pipenv install --verbose -r ./requirements.txt
fi