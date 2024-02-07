# Azure AKS Addons Terraform Module

[![Cluster.dev logo](https://raw.githubusercontent.com/shalb/cluster.dev/master/docs/images/cdev-module-banner.png?sanitize=true)](https://cluster.dev/)

Terraform module that installs core add-ons to Azure Kubernetes Service (AKS) cluster. This Terraform module is also used as part of the [Azure-AKS Cluster.dev stack template](https://github.com/shalb/cdev-azure-aks) to start and provision an AKS cluster with add-ons in Azure cloud.

## Features

The module installs the following add-ons to an AKS cluster:

1. **Argo CD**: Continuous Delivery for Kubernetes.

2. **Ingress-Nginx**: A high-performance, production-ready HTTP and HTTPS Ingress controller for Kubernetes.

3. **External-DNS**: Automatically configure DNS records for your Kubernetes services.

4. **External-Secrets**: Manage sensitive information securely in Kubernetes using Azure Key Vault.

5. **Cert-Manager**: Automate the management and issuance of TLS certificates for your applications.

## Usage  

To use this Terraform module to provision an AKS cluster with the specified add-ons, follow these steps:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/shalb/azure-aks-addons.git
   ```

2. **Configure variables**: Create a `terraform.tfvars` file or provide variables inline to customize your AKS cluster and add-on configurations. For example:
   ```hcl
   location: "eastus"
   cluster_name = "my-aks-cluster"
   cluster_resource_group_name:"aksClusterResGroup"
   domain_name: "test.cluster.dev"
   dns_zone_resource_group_name: "dnsZoneResGroup"
   # Add-on configuration
   enable_argocd            = true
   enable_ingress_nginx     = true
   enable_external_dns      = true
   enable_external_secrets  = true
   enable_cert_manager      = true
   ```
3. **Apply the configuration**:
   ```hcl
   terraform apply
   ```

4. **Access Kubernetes cluster**: After the provisioning is complete, you can access your AKS cluster using `kubectl`:
   ```css
   az aks get-credentials --name <cluster_name> --resource-group <cluster_resource_group_name> --overwrite-existing
   ```

5. **Manage add-ons**: The specified add-ons will be automatically deployed and configured in your AKS cluster.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.75.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.11.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.20.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.75.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.11.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.20.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.cert_manager](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_federated_identity_credential.external_dns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_federated_identity_credential.external_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_role_assignment.cert_manager_dns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.external_dns_dns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.external_dns_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.external_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.external_secrets_certificate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.cert_manager](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.external_dns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.external_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cluster_issuer_letsencrypt](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external_secrets](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.reloader](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret.azure_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_dns_zone.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone) | data source |
| [azurerm_kubernetes_cluster.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_resource_group.dns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_chart_version"></a> [argocd\_chart\_version](#input\_argocd\_chart\_version) | ArgoCD helm chart version | `string` | `"5.53.10"` | no |
| <a name="input_argocd_image_tag"></a> [argocd\_image\_tag](#input\_argocd\_image\_tag) | Argocd docker image version | `string` | `"v2.8.9"` | no |
| <a name="input_argocd_password_bcrypted"></a> [argocd\_password\_bcrypted](#input\_argocd\_password\_bcrypted) | Bctypted password (hash) for argocd web ui | `string` | `""` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Cert Manager helm chart version | `string` | `"v1.13.3"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the AKS cluster | `string` | n/a | yes |
| <a name="input_cluster_resource_group_name"></a> [cluster\_resource\_group\_name](#input\_cluster\_resource\_group\_name) | Name of the resorce group name AKS cluster is provisioned in | `string` | n/a | yes |
| <a name="input_dns_zone_resource_group_name"></a> [dns\_zone\_resource\_group\_name](#input\_dns\_zone\_resource\_group\_name) | Resource group name in which DNS Zone is deployed | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name used | `string` | n/a | yes |
| <a name="input_email"></a> [email](#input\_email) | Email to use for cert manager | `string` | `""` | no |
| <a name="input_enable_argocd"></a> [enable\_argocd](#input\_enable\_argocd) | Disable/enable ArgoCD | `bool` | `false` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Disable/enable Cert Manager | `bool` | `false` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_dns](#input\_enable\_external\_dns) | Disable/enable External DNS | `bool` | `false` | no |
| <a name="input_enable_external_secrets"></a> [enable\_external\_secrets](#input\_enable\_external\_secrets) | Disable/enable External Secrets | `bool` | `false` | no |
| <a name="input_enable_nginx"></a> [enable\_nginx](#input\_enable\_nginx) | Disable/enable Nginx Ingress | `bool` | `false` | no |
| <a name="input_enable_reloader"></a> [enable\_reloader](#input\_enable\_reloader) | Disbale/enable Reloader | `bool` | `false` | no |
| <a name="input_external_dns_version"></a> [external\_dns\_version](#input\_external\_dns\_version) | External DNS helm chart version | `string` | `"6.31.0"` | no |
| <a name="input_external_secrets_version"></a> [external\_secrets\_version](#input\_external\_secrets\_version) | External Secrets helm chart version | `string` | `"v0.9.11"` | no |
| <a name="input_ingress_nginx_version"></a> [ingress\_nginx\_version](#input\_ingress\_nginx\_version) | Ingress nginx helm chart version | `string` | `"4.9.0"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region | `string` | n/a | yes |
| <a name="input_reloader_version"></a> [reloader\_version](#input\_reloader\_version) | Reloader helm chart version | `string` | `"1.0.63"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_argocd_url"></a> [argocd\_url](#output\_argocd\_url) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
