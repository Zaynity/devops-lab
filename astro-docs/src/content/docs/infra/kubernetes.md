---
title: Kubernetes
description: This page provides documentation and practical guides for using Kubernetes (K3S in my project).
---

This page provides documentation and practical guides for using Kubernetes (K3S in my project).

## Useful `kubectl` Commands

- **Get cluster info**
  ```bash
  kubectl cluster-info
  ```

- **List all nodes**
  ```bash
  kubectl get nodes
  ```

- **List all pods in all namespaces**
  ```bash
  kubectl get pods --all-namespaces
  ```

- **List all services**
  ```bash
  kubectl get svc
  ```

- **Describe a pod**
  ```bash
  kubectl describe pod <pod-name>
  ```

- **View logs of a pod**
  ```bash
  kubectl logs <pod-name>
  ```

- **Execute a command in a running pod**
  ```bash
  kubectl exec -it <pod-name> -- /bin/sh
  ```

- **Apply a manifest**
  ```bash
  kubectl apply -f <file.yaml>
  ```

- **Delete a resource**
  ```bash
  kubectl delete -f <file.yaml>
  ```

## Using `ctr` to Check Local Docker Images

K3S uses containerd instead of Docker. To list local images managed by containerd:

```bash
k3s crictl images
```

## Adding a Local Registry to K3S

To use a local Docker registry with K3S, follow these steps:

1. **Create a local registry container (if not already running):**
   ```bash
   docker run -d -p 5000:5000 --restart=always --name registry registry:2.7
   ```

2. **Configure K3S to use the local registry:**

   Create the file `/etc/rancher/k3s/registries.yaml` with the following content:
   ```yaml
   mirrors:
     "localhost:5000":
       endpoint:
         - "http://localhost:5000"
   ```

3. **Restart K3S to apply the changes:**
   ```bash
   sudo systemctl restart k3s
   ```

4. **Tag and push your image to the local registry:**
   ```bash
   docker tag my-image:latest localhost:5000/my-image:latest
   docker push localhost:5000/my-image:latest
   ```

5. **Reference your image in Kubernetes manifests:**
   ```yaml
   image: localhost:5000/my-image:latest
   ```

---

These steps will help you manage your K3S cluster, inspect images, and use a local registry for development.
