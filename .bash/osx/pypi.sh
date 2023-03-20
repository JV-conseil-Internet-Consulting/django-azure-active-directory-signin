#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#====================================================

# shellcheck source=/dev/null
. ".bash/incl/all.sh"

_jvcl_::get_pypi_status() {
  _jvcl_::h1 "Checking PyPi status..."
  cat <<EOF
Before publishing make sure PyPi is not in Read Only mode for maintenance
👉 https://status.python.org/

Status
EOF
  curl --silent 'https://status.python.org/api/v2/status.json' | jq -r '.status.indicator'
  echo
}

_jvcl_::poetry_build_dry_run() {
  local _version

  _version="$(poetry version --short)"

  _jvcl_::h1 "Running poetry build for v${_version}..."
  poetry build -vvv

  _jvcl_::h1 "Running a publish dry run of v${_version} before publishing it to PyPI"
  poetry publish --username "${PYPI_USERNAME}" --password "${PYPI_PASSWORD}" --dry-run -vvv

}

_jvcl_::check_tag_version() {
  local _github_tags _version
  _github_tags="$(git tag --list --column --sort tag)"
  _version="$(poetry version --short)"
  if [[ $_github_tags =~ $_version ]]; then
    _jvcl_::alert "v${_version} is already released on GitHub"
    cat <<EOF
${_github_tags}

You should update the version number in ./pyproject.toml file...

Or alternatively you can delete it with
git tag --delete ${_version} && git push --delete ${_version}
EOF
    false
  else
    true
  fi
}

_jvcl_::poetry_publish() {
  local _version

  _version="$(poetry version --short)"

  if _jvcl_::ask "Are you ready to publish v${_version} on PyPI"; then

    _jvcl_::h1 "Pushing release v${_version} to GitHub..."
    git tag --sign "${_version}" --message "${_version} release"
    git push "${_version}" --verbose

    _jvcl_::h1 "Pushing release v${_version} to PyPi..."
    echo "https://pypi.org/project/django-azure-active-directory-signin/"
    poetry publish --username "${PYPI_USERNAME}" --password "${PYPI_PASSWORD}" -vvv
  fi
}

if _jvcl_::brew_install_formula "poetry"; then
  if _jvcl_::check_tag_version; then
    _jvcl_::poetry_build_dry_run
    _jvcl_::get_pypi_status
    _jvcl_::poetry_publish
  fi
fi

# cd "$FOLDER_PATH" || exit

# __current_version="$(poetry version --short)"
# __github_tags="$(git tag --list --column --sort tag)"

# echo -e "\n\e[0;35mRunning poetry build for v${__current_version}...\e[0;0m\n"

# poetry build -vvv

# echo -e "\n\e[0;35mRunning a publish dry run of v${__current_version} before publishing it to PyPI...\e[0;0m"

# poetry publish --username "${PYPI_USERNAME}" --password "${PYPI_PASSWORD}" --dry-run -vvv

# if [[ $__github_tags =~ $__current_version ]]; then
#   echo -e "\n\e[37;41mYou should update the version number in pyproject.toml file... v${__current_version} is already released on GitHub: ${__github_tags}\e[0;0m"
#   echo -e "\nOr alternatively you can delete it with git tag --delete ${__current_version}\n"
#   exit 2
# fi

# __capture_lines

# #
# # Check PyPi status before uploading
# #

# echo -e "\n\e[0;35mCheck PyPi status\e[0;0m 👉 https://status.python.org/\n\nBefore publishing make sure PyPi is not in Read Only mode for maintenance.\n"

# open -n -a /Applications/Firefox.app --args "--new-tab" "https://pypi.org/"

# #
# # Are you ready to publish on PyPI?
# #

# echo -e -n "\e[0;33mAre you ready to publish on PyPI? [y/N] "
# echo -e -n '\e[0;0m'
# read -r -n 1
# echo
# if [[ $REPLY =~ ^[Yy]$ ]]; then
#   echo -e "\n\e[0;35mPushing release v${__current_version} to GitHub...\e[0;0m\n"

#   git tag --annotate "${__current_version}" --message "${__current_version} release"
#   git push origin "${__current_version}" --verbose

#   echo -e "\n\e[0;35mPushing release v${__current_version} to PyPi...\e[0;0m https://pypi.org/project/django-azure-active-directory-signin/"

#   poetry publish --username "${PYPI_USERNAME}" --password "${PYPI_PASSWORD}" -vvv
# fi
