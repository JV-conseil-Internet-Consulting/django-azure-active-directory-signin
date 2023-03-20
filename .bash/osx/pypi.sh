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
    echo "https://github.com/JV-conseil-Internet-Consulting/django-azure-active-directory-signin/"
    git pull
    git tag --sign "${_version}" --message "${_version} release"
    git push origin "${_version}" --verbose

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
