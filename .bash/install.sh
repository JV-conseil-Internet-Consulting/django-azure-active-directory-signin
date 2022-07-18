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

printf "Checking if poetry is installed or install it with Homebrew...\n\n"

brew ls --versions poetry || brew install poetry

poetry check
poetry install
poetry update
poetry show --tree

printf "\n\nExporting requirements.txt files...\n"

poetry export --without-hashes -f requirements.txt --output requirements.txt
poetry export --dev --without-hashes -f requirements.txt --output requirements-full.txt

# How do I trim leading and trailing whitespace from each line of some output?
# https://unix.stackexchange.com/a/102229/473393

echo "Triming requirements-dev.txt..."

comm -3 requirements.txt requirements-full.txt | awk '{$1=$1};1' > requirements-dev.txt
rm requirements-full.txt

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