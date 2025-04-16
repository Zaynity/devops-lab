#!/bin/bash
: '
./setup.sh <github_token>
To create token go to github settings > Developer Settings > Personal Access Token (PAT)

Run this script to set up the devops-lab environment on the host machine.
This script is intended to be run on a fresh Ubuntu 24.10 x64 server.
It installs the following:
    - Git
    - Docker
    - K3s
    - Kubectl
    - Helm
'

######## Update and upgrade system packages ########
apt update && upgrade -y

######## Install git with repo ########

apt install git -y
git config --global [user.name](http://user.name/) "name"
git config --global user.email "email@email.com"
mkdir git && cd git

# Check if token is provided as an argument
if [ -z "$1" ]; then
    echo "Error: GitHub token not provided."
    echo "Usage: $0 <github_token>"
    exit 1
fi

# Use the provided token in the git clone command
git clone https://"$1"@github.com/Zaynity/devops-lab.git


######## Install docker ########

# Install dependencies for Docker
apt install apt-transport-https ca-certificates curl software-properties-common -y

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker's official APT repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package index again
apt update

# Install Docker Engine, CLI, and containerd
apt install docker-ce -y


######## Install k3s ########

curl -sfL [https://get.k3s.io](https://get.k3s.io/) | sh -


######## Configure Kubectl ########

# Create the kube config directory if it doesn't exist with -p
mkdir -p $HOME/.kube

# Copy k3s kubeconfig file to the default kube config path
cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config

# Change ownership of the kube config file to the current user
chown $USER:$USER $HOME/.kube/config


######### Install helm ########
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash