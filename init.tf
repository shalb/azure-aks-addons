terraform {
  required_version = ">= 1.2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.75.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.11.0"
    }
    null = {
      version = ">= 3.2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
  }
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate)
  host                   = data.azurerm_kubernetes_cluster.cluster.kube_config[0].host
  token                  = data.azurerm_kubernetes_cluster.cluster.kube_config[0].password
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate)
    host                   = data.azurerm_kubernetes_cluster.cluster.kube_config[0].host
    token                  = data.azurerm_kubernetes_cluster.cluster.kube_config[0].password
  }
}

data "azurerm_kubernetes_cluster" "cluster" {
  name                = var.cluster_name
  resource_group_name = var.cluster_resource_group_name
}

data "azurerm_dns_zone" "primary" {
  name                = var.domain_name
  resource_group_name = var.dns_zone_resource_group_name
}

data "azurerm_resource_group" "dns" {
  name = var.dns_zone_resource_group_name
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}
