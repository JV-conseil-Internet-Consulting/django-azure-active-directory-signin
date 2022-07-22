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

__current_version="$(poetry version --short)"
__github_tags="$(git tag --list --column)"

echo -e "\n\e[0;35mRunning poetry build for v${__current_version}...\e[0;0m\n"

poetry build -vvv

echo -e "\n\e[0;35mRunning a publish dry run of v${__current_version} before publishing it to PyPI...\e[0;0m"

poetry publish --username "${PYPI_USERNAME}" --password "${PYPI_PASSWORD}" --dry-run -vvv

if [[ $__github_tags =~ $__current_version ]]
then
   echo -e "\n\e[37;41mYou should update the version number in pyproject.toml file... v${__current_version} is already released on GitHub: ${__github_tags}\e[0;0m"
   exit 2
fi

read -r -p ""
echo -e "\n$REPLY\n"  # capturing annoying source ~/virtualenvs/.../bin/activate

# read -r -n 1 -p "Are you ready to publish on PyPI? [y/N] "
echo -e -n "\e[0;33mAre you ready to publish on PyPI? [y/N] "
echo -e -n '\e[0;0m'
read -r -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo -e "\n\e[0;35mPushing release v${__current_version} to GitHub...\e[0;0m\n"


    git tag --annotate "${__current_version}" --message "${__current_version} release"
    git push origin "${__current_version}" --verbose

    echo -e "\n\e[0;35mPushing release v${__current_version} to PyPi...\e[0;0m https://pypi.org/project/django-azure-active-directory-signin/"

    poetry publish --username "${PYPI_USERNAME}" --password "${PYPI_PASSWORD}" -vvv
fi