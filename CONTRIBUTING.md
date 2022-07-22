# Contributing to Django Azure Active Directory Sign-In 🔑  <!-- omit in toc -->

First off, thanks for taking the time to contribute!

The following is a set of guidelines for contributing to this repo on GitHub.<!-- These are mostly guidelines, not rules. Use your best judgement, and feel free to propose changes to this document in a pull request.-->

## Table of contents  <!-- omit in toc -->

- [How to contribute](#how-to-contribute)
  - [Reporting bugs](#reporting-bugs)
    - [Before submitting a bug report](#before-submitting-a-bug-report)
    - [How do I submit a bug report?](#how-do-i-submit-a-bug-report)
  - [Suggesting enhancements](#suggesting-enhancements)
    - [Before submitting an enhancement suggestion](#before-submitting-an-enhancement-suggestion)
    - [How do I submit an Enhancement suggestion?](#how-do-i-submit-an-enhancement-suggestion)
  - [Contributing to documentation](#contributing-to-documentation)
  - [Contributing to code](#contributing-to-code)
    - [Picking an issue](#picking-an-issue)
    - [Local development](#local-development)
    - [Pull requests](#pull-requests)
  - [Issue triage](#issue-triage)
    - [Triage steps](#triage-steps)
  - [Git Workflow](#git-workflow)
    - [Release branch](#release-branch)
    - [Bug fix branch](#bug-fix-branch)

## How to contribute

### Reporting bugs

This section guides you through submitting a bug report.
Following these guidelines helps maintainers and the community understand your report, reproduce the behavior, and find related reports.

Before creating bug reports, please check [this list](#before-submitting-a-bug-report) to be sure that you need to create one. When you are creating a bug report, please include as many details as possible. Fill out the Bug Report template, the information it asks helps the maintainers resolve the issue faster.

> **Note:** If you find a **Closed** issue that seems like it is the same thing that you're experiencing, open a new issue and include a link to the original issue in the body of your new one.

#### Before submitting a bug report

- **Check the [Documentation][documentation]** for a list of common questions and problems.
- **Check that your issue does not already exist in the [issue tracker][issues]**.

#### How do I submit a bug report?

Bugs are tracked on the [official issue tracker][issues] where you can create a new one and provide the following information by filling in the Bug Report template.

Explain the problem and include additional details to help maintainers reproduce the problem:

- **Use a clear and descriptive title** for the issue to identify the problem.
- **Describe the exact steps which reproduce the problem** in as many details as possible.
- **Provide your pyproject.toml file** in a [Gist](https://gist.github.com) after removing potential private information (like private package repositories).
- **Provide specific examples to demonstrate the steps to reproduce the issue**. Include links to files or GitHub projects, or copy-paste-able snippets, which you use in those examples.
- **Describe the behavior you observed after following the steps** and point out what exactly is the problem with that behavior.
- **Explain which behavior you expected to see instead and why.**
- **If the problem is an unexpected error being raised**, execute the corresponding command in **debug** mode (the `DEBUG = True` in settings).

Provide more context by answering these questions:

- **Did the problem start happening recently** (e.g. after updating to a new version) or was this always a problem?
- If the problem started happening recently, **can you reproduce the problem in an older version?** What's the most recent version in which the problem doesn't happen?
- **Can you reliably reproduce the issue?** If not, provide details about how often the problem happens and under which conditions it normally happens.

Include details about your configuration and environment:

- **What's the name and version of the OS you're using**?

### Suggesting enhancements

This section guides you through submitting an enhancement suggestion, including completely new features and minor improvements to existing functionality. Following these guidelines helps maintainers and the community understand your suggestion and find related suggestions.

Before creating enhancement suggestions, please check [this list](#before-submitting-an-enhancement-suggestion) as you might find out that you don't need to create one. When you are creating an enhancement suggestion, please [include as many details as possible](#how-do-i-submit-an-enhancement-suggestion). Fill in the Bug Report template, including the steps that you imagine you would take if the feature you're requesting existed.

#### Before submitting an enhancement suggestion

- **Check the [Documentation][documentation]** for a list of common questions and problems.
- **Check that your issue does not already exist in the [issue tracker][issues]**.

#### How do I submit an Enhancement suggestion?

Enhancement suggestions are tracked on the [official issue tracker][issues] where you can create a new one and provide the following information:

- **Use a clear and descriptive title** for the issue to identify the suggestion.
- **Provide a step-by-step description of the suggested enhancement** in as many details as possible.
- **Provide specific examples to demonstrate the steps**..
- **Describe the current behavior** and **explain which behavior you expected to see instead** and why.

### Contributing to documentation

One of the simplest ways to get started contributing to a project is through improving documentation. This project is constantly evolving, this means that sometimes our documentation has gaps. You can help by
adding missing sections, editing the existing content so it is more accessible or creating new content (tutorials, FAQs, etc).

Issues pertaining to the documentation are usually marked with the [documentation](https://github.com/JV-conseil-Internet-Consulting/django-azure-active-directory-signin/labels/documentation) label.

### Contributing to code

#### Picking an issue

> **Note:** If you are a first time contributor, and are looking for an issue to take on, you might want to look for [good first issue](https://github.com/JV-conseil-Internet-Consulting/django-azure-active-directory-signin/labels/good%20first%20issue)
> labelled issues. We do our best to label such issues, however we might fall behind at times. So, ask us.

#### Local development

Refer to the [documentation][documentation] to start using this project.

> **Note:** Local development requires Python 3.9 or newer.

You will first need to clone the repository using `git` and place yourself in its directory:

```bash
git clone git@github.com:JV-conseil-Internet-Consulting/django-azure-active-directory-signin.git
cd django-azure-active-directory-signin
```

> **Note:** We recommend that you use a personal [fork](https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github/fork-a-repo) for this step. If you are new to GitHub collaboration,
> you can refer to the [Forking Projects Guide](https://guides.github.com/activities/forking/).

Your code must always be accompanied by corresponding tests, if tests are not present your code
will not be merged.

#### Pull requests

- Fill in [the required template](https://github.com/JV-conseil-Internet-Consulting/django-azure-active-directory-signin/blob/master/.github/PULL_REQUEST_TEMPLATE.md)
- Be sure that your pull request contains tests that cover the changed or added code.
- If your changes warrant a documentation change, the pull request must also update the documentation.

> **Note:** Make sure your branch is [rebased](https://docs.github.com/en/free-pro-team@latest/github/using-git/about-git-rebase) against the latest main branch. A maintainer might ask you to ensure the branch is
> up-to-date prior to merging your Pull Request if changes have conflicts.

All pull requests, unless otherwise instructed, need to be first accepted into the main branch (`master`).

### Issue triage

If you are helping with the triage of reported issues, this section provides some useful information to assist you in your contribution.

#### Triage steps

1. If debug logs (with stack trace) is not provided and required, request that the issue author provides it.
2. Attempt to reproduce the issue with the reported project version or request further clarification from the issue author.
3. Ensure the issue is not already resolved. You can attempt to reproduce using the latest preview release and/or the project from the main branch.
4. If the issue cannot be reproduced,
   1. clarify with the issue's author,
   2. close the issue or notify `triage`.
5. If the issue can be reproduced,
   1. comment on the issue confirming so
   2. notify `triage`.
   3. if possible, identify the root cause of the issue.
   4. if interested, attempt to fix it via a pull request.

### Git Workflow

All development work is performed against this repository main branch (`master`). All changes are expected to be submitted and accepted to this
branch.

#### Release branch

When a release is ready, the following are required before a release is tagged.

1. A release branch with the prefix `release-`, eg: `release-1.1.0rc1`.
1. A pull request from the release branch to the main branch (`master`) if it's a minor or major release. Otherwise, to the bug fix branch (eg: `1.0`).
   1. The pull request description MUST include the change log corresponding to the release (eg: [#2971](https://github.com/JV-conseil-Internet-Consulting/django-azure-active-directory-signin/pull/2971)).
   1. The pull request must contain a commit that updates [CHANGELOG.md](CHANGELOG.md) and bumps the project version (eg: [#2971](https://github.com/JV-conseil-Internet-Consulting/django-azure-active-directory-signin/pull/2971/commits/824e7b79defca435cf1d765bb633030b71b9a780)).
   1. The pull request must have the `Release` label specified.

Once the branch pull-request is ready and approved, a maintainer will,

1. Tag the branch with the version identifier (eg: `1.1.0rc1`).
2. Merge the pull request once the release is created and assets are uploaded by the CI.

> **Note:** In this case, we prefer a merge commit instead of squash or rebase merge.

#### Bug fix branch

Once a minor version (eg: `1.1.0`) is released, a new branch for the minor version (eg: `1.1`) is created for the bug fix releases. Changes identified
or acknowledged by the project team as requiring a bug fix can be submitted as a pull requests against this branch.

At the time of writing only issues meeting the following criteria may be accepted into a bug fix branch. Trivial fixes may be accepted on a
case-by-case basis.

1. The issue breaks a core functionality and/or is a critical regression.
1. The change set does not introduce a new feature or changes an existing functionality.
1. A new minor release is not expected within a reasonable time frame.
1. If the issue affects the next minor/major release, a corresponding fix has been accepted into the main branch.

> **Note:** This is subject to the interpretation of a maintainer within the context of the issue.

<!-- Definitions -->

[conduct]: https://github.com/JV-conseil-Internet-Consulting/django-azure-active-directory-signin/blob/main/CODE_OF_CONDUCT.md
[contributing]: https://github.com/JV-conseil-Internet-Consulting/django-azure-active-directory-signin/blob/main/CONTRIBUTING.md
[documentation]: https://jv-conseil-internet-consulting.github.io/django-azure-active-directory-signin/
[issues]: https://github.com/JV-conseil-Internet-Consulting/django-azure-active-directory-signin/issues
