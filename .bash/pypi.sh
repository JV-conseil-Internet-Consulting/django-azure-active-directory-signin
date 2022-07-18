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

echo "Running a dry run before publishing to PyPI..."

poetry publish --username "${PYPI_USERNAME}" --password "${PYPI_PASSWORD}" --dry-run --verbose

echo
read -p "Do you want to publishing to PyPI? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    poetry publish --username "${PYPI_USERNAME}" --password "${PYPI_PASSWORD}" --verbose
fi