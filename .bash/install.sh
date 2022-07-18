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

echo
read -p "Do you want to set a Poetry environment? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew ls --versions poetry || brew install poetry

    poetry check
    poetry install
    poetry update
    poetry show --tree
    poetry export --without-hashes -f requirements.txt --output requirements.txt
    poetry export --dev --without-hashes -f requirements.txt --output requirements-full.txt
    comm -3 requirements.txt requirements-full.txt > requirements-dev.txt
    rm requirements-full.txt
fi

# Pipenv install

echo
read -p "Do you want to set a Pipenv environment? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew ls --versions pipenv || brew install pipenv

    pipenv --rm
    sudo pipenv --clear  # clear cache
    pipenv install --verbose -d -r ./requirements-dev.txt
    pipenv install --verbose -r ./requirements.txt
fi