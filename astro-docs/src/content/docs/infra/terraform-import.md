---
title: Import Existing DigitalOcean Droplet to Terraform
description: Complete guide to import an existing DigitalOcean droplet into Terraform management
---

This guide walks you through the complete process of importing an existing DigitalOcean droplet into Terraform, from initial setup to successful management.

## Prerequisites

- An existing DigitalOcean droplet
- DigitalOcean account with API access
- Basic knowledge of command line operations

## Step 1: Install and Configure doctl

### Install doctl CLI

**On Ubuntu:**
```bash
# To install the latest version of doctl using Snap on Ubuntu or other supported operating systems, run:
sudo snap install doctl

# For security purposes, Snaps run in complete isolation and need to be granted permission to interact with your system’s resources. Some doctl commands require additional permissions:

# Using doctl’s integration with kubectl requires the kube-config personal-files interface. To enable it, run:
sudo snap connect doctl:kube-config

# Using doctl compute ssh requires the core ssh-keys interface. To enable it, run:
sudo snap connect doctl:ssh-keys :ssh-keys

# Using doctl registry login requires the dot-docker personal-files interface. To enable it, run:
sudo snap connect doctl:dot-docker
```

### Create DigitalOcean API Token

1. Go to [DigitalOcean Control Panel](https://cloud.digitalocean.com/account/api/tokens)
2. Click **"Generate New Token"**
3. Give it a name (e.g., "terraform-management")
4. Select **"Read and Write"** scope
5. Copy the generated token

### Configure doctl

```bash
# Authenticate doctl with your token
doctl auth init

# Test the configuration
doctl account get
```

## Step 2: Gather Droplet Information

### List Your Droplets

```bash
# Get detailed information about all droplets
doctl compute droplet list
```

### Example Output

```
ID           Name          Public IPv4    Private IPv4    Memory    VCPUs    Disk    Region    Image               VPC UUID                                Status    Tags    Features
488978456    devops-lab    178.62.2.28    10.106.0.2      4096      2        100     lon1      Ubuntu 24.10 x64    31593245-8cab-4488-b476-289f987345b2    active            monitoring,droplet_agent,private_networking
```

**Note down these important details:**
- **Droplet ID**: `488978456`
- **Size**: Based on VCPUs/Memory (e.g., `s-2vcpu-4gb-120gb-intel`)
- **Region**: `lon1`
- **Image**: `ubuntu-24-10-x64`
- **VPC UUID**: `31593245-8cab-4488-b476-289f987345b2`
- **Features**: `monitoring`, `droplet_agent`, etc.

## Step 3: Install Terraform

### Download and Install Terraform

**On Ubuntu/Debian:**
```bash
# Ensure that your system is up to date and that you have installed the gnupg and software-properties-common packages. You will use these packages to verify HashiCorp's GPG signature and install HashiCorp's Debian package repository.
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

# Install HashiCorp's GPG key.
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

# Verify the GPG key's fingerprint.
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

# The gpg command reports the key fingerprint:
/usr/share/keyrings/hashicorp-archive-keyring.gpg
-------------------------------------------------
pub   rsa4096 XXXX-XX-XX [SC]
AAAA AAAA AAAA AAAA
uid         [ unknown] HashiCorp Security (HashiCorp Package Signing) <security+packaging@hashicorp.com>
sub   rsa4096 XXXX-XX-XX [E]

# Add the official HashiCorp repository to your system.
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update apt to download the package information from the HashiCorp repository.
sudo apt update

# Install Terraform from the new repository.
sudo apt-get install terraform
```

### Verify Terraform Installation

```bash
terraform version
```

## Step 4: Create Terraform Configuration

### Project Structure

Create your Terraform project directory:

```bash
mkdir -p terraform/digitalocean
cd terraform/digitalocean
```

### Create Provider Configuration

Create `provider.tf`:

```hcl
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.15.0"
    }
  }
}

variable "do_token" {
  description = "DigitalOcean Personal Access Token"
  type        = string
  sensitive   = true
}

provider "digitalocean" {
  token = var.do_token
}
```

### Create Droplet Resource Configuration

Create `digitalocean_droplet.tf` with the **exact specifications** of your existing droplet:

```hcl
resource "digitalocean_droplet" "do_droplet" {
    name       = "devops-lab"                    # Exact name from doctl output
    region     = "lon1"                          # Exact region
    size       = "s-2vcpu-4gb-120gb-intel"       # Match the actual size
    image      = "ubuntu-24-10-x64"              # Exact image
    tags       = ["devops-lab", "k3s", "monitoring", "production"]
    monitoring = true                            # If monitoring is enabled
    vpc_uuid   = "31593245-8cab-4488-b476-289f987345b2"  # Exact VPC UUID
}
```

:::tip[Important Configuration Notes]
- The **size** must match exactly (check with `doctl compute size list`)
- **VPC UUID** must be the exact one from your droplet
- **DO NOT** include `droplet_agent = true` as it forces replacement
:::

### Create .gitignore

Create `.gitignore` to protect sensitive files:

```gitignore
# Terraform files to exclude from version control
**/.terraform/*
*.tfstate
*.tfstate.*
crash.log
crash.*.log
*.tfvars
*.tfvars.json
override.tf
override.tf.json
*_override.tf
*_override.tf.json
*tfplan*
.terraformrc
terraform.rc
.env
.env.*
*.pem
*.key
id_rsa*
id_ed25519*
.DS_Store
.vscode/
.idea/
```

## Step 5: Initialize and Import

### Set Environment Variable

```bash
# Export your DigitalOcean token in your CLI
export DO_TOKEN="your_digitalocean_token_here"
```

### Initialize Terraform

```bash
# Initialize Terraform and download providers
terraform init
```

### Import the Existing Droplet

```bash
# Import using the droplet ID from Step 2
terraform import -var "do_token=${DO_TOKEN}" digitalocean_droplet.do_droplet 488978456
```

### Verify the Import

```bash
# Check the current state
terraform show

# Plan to see what changes would be made
terraform plan -var "do_token=${DO_TOKEN}"
```

## Step 6: Validate Configuration

### Expected Plan Output

After a successful import, `terraform plan` should show:

```
Plan: 0 to add, 1 to change, 0 to destroy.
```

**✅ Good signs:**
- `0 to destroy` - No resources will be deleted
- Only minor changes like tags or metadata

**⚠️ Warning signs:**
- `destroy and then create replacement` - Configuration doesn't match
- Size or region differences

### Common Issues and Solutions

**Issue: Configuration mismatch**
```
-/+ resource "digitalocean_droplet" "do_droplet" must be replaced
```

**Solution:** Update your configuration to match exactly:
- Check droplet size with `doctl compute size list`
- Verify image name with `doctl compute image list-distribution`
- Ensure VPC UUID is correct

**Issue: Droplet agent forces replacement**
```
+ droplet_agent = true # forces replacement
```

**Solution:** Remove `droplet_agent = true` from your configuration.

## Step 7: Apply Changes (If Needed)

### Safe Apply

If your plan shows only safe changes (tags, metadata):

```bash
# Apply the changes
terraform apply -var "do_token=${DO_TOKEN}"
```

### Verify Management

```bash
# Test that Terraform can manage the resource
terraform plan -var "do_token=${DO_TOKEN}"

# Should show: No changes. Your infrastructure matches the configuration.
```

## Troubleshooting

### Common Error Messages

**"Configuration for import target does not exist"**
- Ensure your resource name in the import command matches the configuration
- Verify the resource block exists in your `.tf` files

**"Invalid provider configuration"**
- Check that your DO_TOKEN environment variable is set
- Verify the token has read/write permissions

**"Resource already exists"**
- The droplet is already imported - run `terraform plan` to verify

### Getting Help

- Check [Terraform DigitalOcean Provider Documentation](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs)
- Review [DigitalOcean API Documentation](https://docs.digitalocean.com/reference/api/)
- Use `terraform plan` frequently to understand what changes will be made

## Security Best Practices

1. **Never commit tokens**: Always use environment variables or secure secret management
2. **Use .gitignore**: Protect state files and sensitive configurations
3. **Limit token scope**: Create tokens with minimal required permissions
4. **Regular rotation**: Rotate API tokens periodically
5. **State file security**: Consider remote state storage for production environments

---

This process allows you to bring existing infrastructure under Terraform management without any downtime or data loss. The key is ensuring your configuration exactly matches your existing infrastructure before applying any changes.
