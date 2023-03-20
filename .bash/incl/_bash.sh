#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#
# GNU bash, version 5.2.15(1)-release (aarch64-apple-darwin21.6.0)
#
#====================================================

_jvcl_::set_homebrew_bash() {
  local _bash="${HOMEBREW_PREFIX}/bin/bash"
  if ! grep -F -q "${_bash}" "/etc/shells"; then
    echo "${HOMEBREW_PREFIX}/bin/bash" | sudo tee -a "/etc/shells" >/dev/null
  fi
  chsh -s "${_bash}"
}

if _jvcl_::is_formula_installed bash _jvcl_::set_homebrew_bash && [ $((${BASH_VERSION:0:1})) -ge 5 ]; then
  echo "Bash ${BASH_VERSION}" &>/dev/null # NOTE: no version display at this step
fi
