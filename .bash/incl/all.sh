#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#====================================================

# shellcheck disable=SC2034
declare -A REPO_PARAM
declare -ix DEBUG=0 BASH_STRICT_MODE=0
declare -x SECRET_KEY

REPO_PARAM=(
  [env]="${HOME}/.env/django-azure-active-directory-signin/.env"
  [cache]="./cache"
  [postgresql]="14"
  [python]="3.11"
  [DBNAME]="welcome"
  [DBHOST]="localhost"
  [DBPORT]="5432"
  [DBSSLMODE]="disable"
  [DBUSER]="manager"
)

# shellcheck source=/dev/null
{
  . "${REPO_PARAM[env]}" || :
  . "settings.conf"
  . ".bash/incl/_set.sh"
  . ".bash/incl/_aliases.sh"
  . ".bash/incl/_colors.sh"
  . ".bash/incl/_utils.sh"
  . ".bash/incl/_debug.sh"
  . ".bash/incl/_homebrew.sh"
  . ".bash/incl/_bash.sh"
  . ".bash/incl/_python.sh"
  # more files
}

SECRET_KEY="$(_jvcl_::key_gen 128)"

_jvcl_::debug
