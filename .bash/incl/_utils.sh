#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#====================================================

_jvcl_::key_gen() {
  # e.g.: $(_jvcl_::key_gen 128)
  local _size=${1:-15}
  if type python &>/dev/null; then
    python -c "import secrets; result = ''.join(secrets.choice('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-+') for i in range($_size)); print(result)"
  else
    openssl rand -base64 "${_size}"
  fi
}

_jvcl_::capture_lines() {
  # capturing annoying source ~/virtualenvs/.../bin/activate
  read -r -p ""
  if [ -n "${REPLY}" ]; then
    echo "${REPLY}"
  fi
  echo "Press any key to continue..."
  echo
}
