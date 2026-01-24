# 🐳 kind-cluster-stack

A production-ready Kubernetes cluster provisioning solution using KinD (Kubernetes in Docker) with integrated DevOps tools for GitOps, secrets management, certificate automation, and container registry.

---

## ✨ Features

- 🎯 **KinD Cluster**: Local Kubernetes cluster setup for development and testing
- 🔄 **ArgoCD**: GitOps continuous deployment and application management
- 🔐 **HashiCorp Vault**: Secure secrets management and encryption
- 🔒 **Cert-Manager**: Automated TLS certificate provisioning and renewal
- 🏗️ **Harbor**: Enterprise-grade container registry and image management
- 🌩️ **Cloud Provider Integration**: Multi-cloud provider support
- 📦 **Infrastructure-as-Code**: Terraform for reproducible infrastructure
- 📊 **Helm Charts**: Declarative application deployment with customizable values

---

## 📋 Prerequisites

- Docker & Docker Daemon running
- Terraform >= 1.0
- kubectl >= 1.20
- Helm >= 3.0
- bash/shell environment

---

## 🚀 Quick Start

### 1. Initialize Terraform
```bash
cd iaac
terraform init
```

### 2. Review and Customize Variables
```bash
# Edit variables in iaac/variabels.tf to customize your cluster setup
cat iaac/variabels.tf
```

### 3. Preview Changes
```bash
terraform plan
```

### 4. Deploy the Stack
```bash
terraform apply
```

### 5. Access the Cluster
```bash
kubectl cluster-info
kubectl get nodes
```

---

## 📁 Project Structure

```
kind-cluster-stack/
├── iaac/                           # Infrastructure-as-Code (Terraform)
│   ├── providers.tf               # Terraform provider configuration
│   ├── variabels.tf               # Input variables and configurations
│   ├── kind.tf                    # KinD cluster definition
│   ├── argocd.tf                  # ArgoCD deployment and setup
│   ├── vault.tf                   # Vault secrets management setup
│   ├── cert-manager.tf            # Cert-Manager installation
│   ├── harbor.tf                  # Harbor container registry setup
│   ├── ca.tf                      # Certificate authority configuration
│   ├── cloud-provider-kind.tf     # Cloud provider integration for KinD
│   ├── argocd/
│   │   └── values.yaml            # ArgoCD Helm chart values
│   └── vault/
│       └── values.yaml            # Vault Helm chart values
│
└── README.md                      # This file
```

---

## 🔧 Components

### 🐳 KinD Cluster
Lightweight Kubernetes cluster running in Docker. Defined and managed through `iaac/kind.tf`. Perfect for local development, testing, and CI/CD pipelines.

### 🔄 ArgoCD
GitOps continuous deployment tool. Configured via `iaac/argocd.tf` with custom Helm values in `iaac/argocd/values.yaml`. Enables declarative application deployment synced from Git repositories.

### 🔐 Vault
Enterprise-grade secrets management engine. Set up through `iaac/vault.tf` with Helm values in `iaac/vault/values.yaml`. Securely stores and manages sensitive data across your infrastructure.

### 🔒 Cert-Manager
Automated TLS certificate management. Installed and configured via `iaac/cert-manager.tf`. Simplifies certificate provisioning and renewal workflows.

### 🏗️ Harbor
Private container registry with vulnerability scanning. Managed through `iaac/harbor.tf`. Supports image replication, helm chart storage, and enterprise features.

### 🌩️ Cloud Provider & CA
- **Cloud Provider** (`iaac/cloud-provider-kind.tf`): Enables cloud provider integration for multi-cloud deployments
- **Certificate Authority** (`iaac/ca.tf`): Manages certificate authority configuration and PKI setup

---

## 🛠️ Terraform Workflow

### Initialize (First time only)
```bash
cd iaac
terraform init
```

### Plan and Review
```bash
terraform plan
```

### Apply Configuration
```bash
terraform apply
```

### Check State
```bash
terraform show
```

### Destroy Infrastructure
```bash
terraform destroy
```

---

## 📝 Configuration & Customization

### Cluster Variables
Edit `iaac/variabels.tf` to customize:
- Cluster name and Kubernetes version
- Number of control-plane and worker nodes
- Node resource allocation (CPU, memory)
- Network configuration
- Storage settings

### Service Configuration
Modify Helm values for specific components:

**ArgoCD** (`iaac/argocd/values.yaml`):
```yaml
# Customize ArgoCD deployment, ingress, RBAC, etc.
```

**Vault** (`iaac/vault/values.yaml`):
```yaml
# Customize Vault storage, HA setup, authentication methods
```

### Provider Configuration
Edit `iaac/providers.tf` to adjust:
- Terraform version requirements
- Provider versions (kind, kubectl, helm)

---

## 📊 Terraform Files Overview

| File | Purpose |
|------|---------|
| `providers.tf` | Defines Terraform and provider versions |
| `variabels.tf` | Input variables for cluster customization |
| `kind.tf` | KinD cluster resource definition |
| `argocd.tf` | ArgoCD namespace, Helm chart, and configuration |
| `vault.tf` | Vault namespace, storage, and Helm setup |
| `cert-manager.tf` | Cert-Manager CRDs, Helm deployment |
| `harbor.tf` | Harbor registry Helm deployment |
| `ca.tf` | Certificate authority and TLS setup |
| `cloud-provider-kind.tf` | Cloud provider plugins and configuration |

---

## 📖 Common Operations

### Check Cluster Status
```bash
kubectl cluster-info
kubectl get nodes
kubectl get all -A
```

### View ArgoCD Status
```bash
kubectl get all -n argocd
kubectl port-forward -n argocd svc/argocd-server 8080:443
# Access at https://localhost:8080
```

### Access Vault
```bash
kubectl port-forward -n vault svc/vault 8200:8200
# Access Vault UI at http://localhost:8200
```

### Check Harbor Registry
```bash
kubectl get all -n harbor
# Check Harbor ingress or port-forward for access
```

### View Certificate Manager
```bash
kubectl get all -n cert-manager
kubectl get certificate -A
```

---

## 🔗 Integration Points

This stack is designed for:
- 🌍 **Multi-cloud deployments**: AWS, GCP, Azure compatibility
- 📡 **Custom networking**: DNS, ingress, and network policy support
- 🔑 **OIDC & SSO**: Integration with identity providers
- 📊 **Monitoring**: Ready for Prometheus, Grafana, or similar tools
- 🔄 **GitOps workflows**: Full ArgoCD integration
- 🔐 **Secret management**: Vault integration for all sensitive data

---

## 📚 Resources & Documentation

- [KinD Documentation](https://kind.sigs.k8s.io/)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [HashiCorp Vault Docs](https://www.vaultproject.io/docs)
- [Cert-Manager Documentation](https://cert-manager.io/docs/)
- [Harbor Documentation](https://goharbor.io/docs/)
- [Terraform Documentation](https://www.terraform.io/docs)

---

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 💬 Support

For issues, questions, or suggestions, please open an issue on GitHub or contact the maintainers.

---

**Happy Clustering! 🚀**
