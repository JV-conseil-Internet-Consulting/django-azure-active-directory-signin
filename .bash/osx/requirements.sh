#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# licence       : BSD 3-Clause License
# copyright     : Copyright (c) 2022-2023 JV-conseil
#                 All rights reserved
#====================================================


# shellcheck disable=SC1091
source ".bash/osx/bash_alias.sh"


cd "$FOLDER_PATH" || exit


echo -e "\n\e[0;35mExporting requirements.txt files...\e[0;0m"

poetry export --without-hashes -f requirements.txt --output requirements.txt
poetry export --with dev --without-hashes -f requirements.txt --output requirements-full.txt

# How do I trim leading and trailing whitespace from each line of some output?
# https://unix.stackexchange.com/a/102229/473393

echo "Triming requirements-dev.txt..."

comm -3 requirements.txt requirements-full.txt | awk '{$1=$1};1' > requirements-dev.txt
rm -rf requirements-full.txt
