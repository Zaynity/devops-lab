---
title: General Documentation Page
description: Default documentation page with essential setup instructions.
---

## Generate SSH Public & Private Keys for GitHub Actions Workflows

To generate a new SSH key pair, run this on Local PC with OpenSSL installed:

```bash
ssh-keygen -t ed25519 -f id_ed25519
```

- This will create `id_ed25519` (private key) and `id_ed25519.pub` (public key) in your current directory.

### Store the Private Key as a GitHub Actions Secret

- Go to your repository secrets:  
  https://github.com/your_repo/settings/secrets/actions
- Add the contents of your **private key** (`id_ed25519`) as a new secret.

###  Add the Public Key to the Droplet

- Copy the entire contents of your `id_ed25519.pub` file.
- On your droplet, append it to `/root/.ssh/authorized_keys`:

```bash
cat id_ed25519.pub >> /root/.ssh/authorized_keys
```

This setup allows GitHub Actions to connect securely to your server using SSH keys.
