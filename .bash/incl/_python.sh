#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#====================================================

alias python=python3

if _jvcl_::is_formula_installed "python@${REPO_PARAM[python]}"; then
  export PATH="${HOMEBREW_PREFIX}/opt/python@${REPO_PARAM[python]}/libexec/bin:$PATH"
  export PYTHONPATH="${HOMEBREW_PREFIX}/bin/python${REPO_PARAM[python]}"
  export PATH="${PYTHONPATH}/bin:$PATH"
  export LDFLAGS="-L${PYTHONPATH}/lib"
  export PKG_CONFIG_PATH="${PYTHONPATH}/lib/pkgconfig"
  # python --version
fi
