
resource "helm_release" "external_dns" {
  count      = var.enable_external_dns ? 1 : 0
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.external_dns_version
  values = [
    <<-EOF
  podLabels:
    azure.workload.identity/use: "true"
  azure:
    secretName: azure-config-file
      EOF
  ]
  set {
    name  = "fullnameOverride"
    value = "external-dns"
  }
  set {
    name  = "provider"
    value = "azure"
  }
  set {
    name  = "serviceAccount.annotations.azure\\.workload\\.identity/client-id"
    value = azurerm_user_assigned_identity.external_dns[0].client_id
  }

  depends_on = [
    kubernetes_secret.azure_config,
    azurerm_federated_identity_credential.external_dns
  ]
}

resource "azurerm_user_assigned_identity" "external_dns" {
  count               = var.enable_external_dns ? 1 : 0
  resource_group_name = data.azurerm_kubernetes_cluster.cluster.resource_group_name
  name                = "external-dns"
  location            = var.location
}

resource "azurerm_role_assignment" "external_dns_dns" {
  count                = var.enable_external_dns ? 1 : 0
  scope                = data.azurerm_dns_zone.primary.id
  principal_id         = azurerm_user_assigned_identity.external_dns[0].principal_id
  role_definition_name = "DNS Zone Contributor"
}

resource "azurerm_role_assignment" "external_dns_reader" {
  count                = var.enable_external_dns ? 1 : 0
  scope                = data.azurerm_resource_group.dns.id
  principal_id         = azurerm_user_assigned_identity.external_dns[0].principal_id
  role_definition_name = "Reader"
}

resource "azurerm_federated_identity_credential" "external_dns" {
  count               = var.enable_external_dns ? 1 : 0
  name                = azurerm_user_assigned_identity.external_dns[0].name
  resource_group_name = azurerm_user_assigned_identity.external_dns[0].resource_group_name
  parent_id           = azurerm_user_assigned_identity.external_dns[0].id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = data.azurerm_kubernetes_cluster.cluster.oidc_issuer_url
  subject             = "system:serviceaccount:default:external-dns"

  depends_on = [
    azurerm_role_assignment.external_dns_dns,
    azurerm_role_assignment.external_dns_reader
  ]
}

resource "kubernetes_secret" "azure_config" {
  count = var.enable_external_dns ? 1 : 0

  metadata {
    name      = "azure-config-file"
    namespace = "default"
  }

  data = {
    "azure.json" = jsonencode({
      subscriptionId               = data.azurerm_subscription.current.subscription_id
      resourceGroup                = var.dns_zone_resource_group_name
      useWorkloadIdentityExtension = true
    })
  }
}
