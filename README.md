# DevOps Lab Environment

Welcome to my personal DevOps lab repository. This space is designed for experimentation and learning around modern DevOps tooling, infrastructure automation, and CI/CD practices.

This project is evolving over time as I integrate and test different technologies and workflows. For now, the setup includes a basic Kubernetes cluster with a local Docker registry and a documentation website.

[Documentation](http://178.62.3.69:30080/)

---

## 🔧 Current Stack

| Tool / Tech              | Description                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| **Docker**               | Containerization engine used to build and run images locally.               |
| **K3s**                  | Lightweight Kubernetes distribution used for the cluster setup.             |
| **Docker Registry**      | Local Docker registry used to push/pull container images within the cluster.|
| **Astro Starlight**      | Template used to deploy a documentation site in the K3s cluster.            |
| **GitHub Actions**       | CI/CD pipeline to automate build and deployment.                            |
| **DigitalOcean Droplet** | Hosting environment for the lab (Ubuntu 24.10 x64).                         |

---

## 📌 Goals

- Build a robust and modular DevOps lab environment.
- Test CI/CD practices with real-world tools.
- Deploy and manage applications using infrastructure-as-code.
- Document the setup and findings with Astro Starlight.

---

## 🌐 Deployment Overview

The environment is currently hosted on a [DigitalOcean](https://www.digitalocean.com) droplet running **Ubuntu 24.10 x64**.

## 🛠️ How to Use

Import the /scripts/setup.sh on the server and run it with the following command
```bash
./setup.sh replace_by_github_token
```
