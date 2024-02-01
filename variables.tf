variable "domain_name" {
  type        = string
  description = "Domain name used"
}

variable "dns_zone_resource_group_name" {
  type        = string
  description = "Resource group name in which DNS Zone is deployed"
}

variable "cluster_name" {
  type        = string
  description = "Name of the AKS cluster"
}

variable "cluster_resource_group_name" {
  type        = string
  description = "Name of the resorce group name AKS cluster is provisioned in"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "enable_nginx" {
  type        = bool
  default     = false
  description = "Disable/enable Nginx Ingress"
}

variable "ingress_nginx_version" {
  type        = string
  default     = "4.9.0"
  description = "Ingress nginx helm chart version"
}

variable "enable_external_dns" {
  type        = bool
  default     = false
  description = "Disable/enable External DNS"
}

variable "external_dns_version" {
  type        = string
  default     = "6.31.0"
  description = "External DNS helm chart version"
}

variable "enable_cert_manager" {
  type        = bool
  default     = false
  description = "Disable/enable Cert Manager"
}

variable "cert_manager_version" {
  type        = string
  default     = "v1.13.3"
  description = "Cert Manager helm chart version"
}

variable "email" {
  type        = string
  default     = ""
  description = "Email to use for cert manager"
}

variable "enable_external_secrets" {
  type        = bool
  default     = false
  description = "Disable/enable External Secrets"
}

variable "external_secrets_version" {
  type        = string
  default     = "v0.9.11"
  description = "External Secrets helm chart version"
}

variable "enable_argocd" {
  type        = bool
  default     = false
  description = "Disable/enable ArgoCD"
}

variable "argocd_chart_version" {
  type        = string
  default     = "5.53.10"
  description = "ArgoCD helm chart version"
}

variable "argocd_image_tag" {
  type        = string
  default     = "v2.8.9"
  description = "Argocd docker image version"
}

variable "argocd_password_bcrypted" {
  type        = string
  description = "Bctypted password (hash) for argocd web ui"
  default     = ""
}

variable "enable_reloader" {
  type        = bool
  default     = false
  description = "Disbale/enable Reloader"
}

variable "reloader_version" {
  type        = string
  description = "Reloader helm chart version"
  default     = "1.0.63"
}
