#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#====================================================

# Set PATH, MANPATH, etc., for Homebrew for M1
case $(arch) in
arm64) # M1
  eval "$(/opt/homebrew/bin/brew shellenv)"

  ;;
i386) # Intel
  # Warning: Homebrew's "sbin" was not found in your PATH but you have installed
  # formulae that put executables in /usr/local/sbin.
  # Consider setting your PATH for example like so:
  export PATH="/usr/local/sbin:$PATH"
  export HOMEBREW_PREFIX="/usr/local"
  ;;
esac

_jvcl_::brew_install_formula() {
  if _jvcl_::is_homebrew_installed; then
    _jvcl_::h1 "Checking if ${1} is installed..."
    brew ls --versions "${1}" || brew install "${1}"
  fi
}

_jvcl_::is_formula_installed() {
  local _formula="${1}" _type

  _type="${_formula}"

  if [[ "${_formula}" == "postgresql@"* ]]; then _type="psql"; fi
  if [[ "${_formula}" == "python@"* ]]; then _type="python"; fi
  if [[ "${_formula}" == "visual-studio-code"* ]]; then _type="code"; fi

  if type "${_type}" &>/dev/null; then
    true
  elif _jvcl_::ask "Do you want to install ${_formula}"; then
    brew install "${_formula}"
    # "${2:-}" # extra func passed as an argument e.g.: _jvcl_::is_formula_installed bash _jvcl_::set_homebrew_bash
    if [ -n "${2:-}" ]; then
      "${2}"
    fi
    true
  else
    false
  fi
}

_jvcl_::is_homebrew_installed() {
  if type brew &>/dev/null; then
    true
  elif _jvcl_::ask "Do you want to install Homebrew"; then
    _jvcl_::h3 "Installing Homebrew"
    curl -fsSL "https://raw.githubusercontent.com/Homebrew/install/master/install.sh"
    true
  else
    false
  fi
}

_jvcl_::update_mas() {
  mas list
  mas upgrade
}

_jvcl_::update_homebrew() {
  local _opt
  for _opt in "config" "doctor" "update" "upgrade" "autoremove" "cleanup"; do
    brew "${_opt}" --verbose || :
  done

  # You can dump a Brewfile of your current brew/cask/mas entries into your current directory with
  # https://gist.github.com/ChristopherA/a579274536aab36ea9966f301ff14f3f#creating-a-brewfile
  brew bundle dump --force --file="${HOME}/Brewfile"

  # Update pip
  python3 -m pip install --upgrade pip
}
