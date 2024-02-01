resource "helm_release" "external_secrets" {
  count            = var.enable_external_secrets ? 1 : 0
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = var.external_secrets_version
  create_namespace = true
  namespace        = "external-secrets"

  values = [
    <<-EOF
  replicaCount: 1
  podLabels:
    azure.workload.identity/use: "true"
  installCRDs: true
  controllerClass:
  serviceAccount:
    create: true
    annotations:
      azure.workload.identity/client-id: ${azurerm_user_assigned_identity.external_secrets[0].client_id}
      azure.workload.identity/tenant-id: ${data.azurerm_client_config.current.tenant_id}
    name: external-secrets
  resources:
    requests:
      cpu: 0.1
      memory: 200Mi
    limits:
      cpu: 0.3
      memory: 400Mi
  prometheus:
    enabled: false
  env:
    POLLER_INTERVAL_MILLISECONDS: 10000
      EOF
  ]
}

resource "azurerm_user_assigned_identity" "external_secrets" {
  count               = var.enable_external_secrets ? 1 : 0
  resource_group_name = data.azurerm_kubernetes_cluster.cluster.resource_group_name
  name                = "external-secrets"
  location            = var.location
}

// TODO: Review permissions scope

resource "azurerm_role_assignment" "external_secrets" {
  count                = var.enable_external_secrets ? 1 : 0
  scope                = data.azurerm_subscription.current.id
  principal_id         = azurerm_user_assigned_identity.external_secrets[0].principal_id
  role_definition_name = "Key Vault Secrets User"
}

resource "azurerm_role_assignment" "external_secrets_certificate" {
  count                = var.enable_external_secrets ? 1 : 0
  scope                = data.azurerm_subscription.current.id
  principal_id         = azurerm_user_assigned_identity.external_secrets[0].principal_id
  role_definition_name = "Key Vault Certificate User"
}

resource "azurerm_federated_identity_credential" "external_secrets" {
  count               = var.enable_external_secrets ? 1 : 0
  name                = azurerm_user_assigned_identity.external_secrets[0].name
  resource_group_name = azurerm_user_assigned_identity.external_secrets[0].resource_group_name
  parent_id           = azurerm_user_assigned_identity.external_secrets[0].id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = data.azurerm_kubernetes_cluster.cluster.oidc_issuer_url
  subject             = "system:serviceaccount:external-secrets:external-secrets"

  depends_on = [
    azurerm_role_assignment.external_secrets,
    azurerm_role_assignment.external_secrets_certificate
  ]
}
