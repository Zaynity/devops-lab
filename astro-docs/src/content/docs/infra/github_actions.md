---
title: GitHub Actions
description: This page provides documentation and practical guides for using GitHub Actions.
---
This page provides documentation and practical guides for using GitHub Actions.

## Creating Secrets in GitHub Actions

Secrets in GitHub Actions are used to securely store sensitive information such as API keys, tokens, or passwords. These secrets can be referenced in your workflows without exposing them in your code.

### How to Create a Secret

1. Go to your GitHub repository on github.com.
2. Click on **Settings**.
3. In the sidebar, click on **Secrets and variables** > **Actions**.
4. Click the **New repository secret** button.
5. Enter a name for your secret (e.g., `MY_SECRET_TOKEN`) and its value.
6. Click **Add secret**.

You can now use this secret in your GitHub Actions workflow like this:
```yaml
env:
  MY_SECRET_TOKEN: ${{ secrets.MY_SECRET_TOKEN }}
```

### Types of Secrets

There are two main types of secrets in GitHub Actions:

- **Repository Secrets**:  
  These are scoped to a single repository. They are only accessible by workflows running in that repository.
  (Ideal for personal or smaller projects).

- **Environment Secrets**:  
  These are associated with a specific environment (e.g., `production`, `staging`). They can be used to restrict access to secrets based on the environment and can provide additional protection, such as required approvals before deployment.
  (Ideal for larger projects).

---

## Creating a Workflow in GitHub Actions

A workflow is a configurable automated process made up of one or more jobs. Workflows are defined in YAML files stored in the `.github/workflows/` directory of your repository.

### Example: Basic Workflow Using a Secret

1. Create a new file in your repository at `.github/workflows/ci.yml`.
2. Add the following content:

```yaml
name: CI Example

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Print secret
        run: echo "My secret is $MY_SECRET_TOKEN"
        env:
          MY_SECRET_TOKEN: ${{ secrets.MY_SECRET_TOKEN }}
```

This workflow runs on every push to the `main` branch and prints the value of your secret (for demonstration purposes only—never print real secrets in production).

---
