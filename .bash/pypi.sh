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

poetry build

printf "\nRunning a dry run before publishing to PyPI...\n"

poetry publish --username "${PYPI_USERNAME}" --password "${PYPI_PASSWORD}" --dry-run --verbose

echo
read -r -n 1 -p "Are you ready to publish on PyPI? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo
    poetry publish --username "${PYPI_USERNAME}" --password "${PYPI_PASSWORD}" --verbose
fi