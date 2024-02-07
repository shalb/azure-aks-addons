locals {
  email = var.email == "" ? "devops@${var.domain_name}" : var.email
}

resource "helm_release" "cert_manager" {
  count            = var.enable_cert_manager ? 1 : 0
  create_namespace = true
  namespace        = "cert-manager"
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.cert_manager_version
  values = [
    <<-EOF
  podLabels:
    azure.workload.identity/use: "true"
  serviceAccount:
    labels:
      azure.workload.identity/use: "true"
      EOF
  ]

  set {
    name  = "installCRDs"
    value = true
  }

  depends_on = [
    azurerm_federated_identity_credential.cert_manager
  ]
}

resource "helm_release" "cluster_issuer_letsencrypt" {
  count      = var.enable_cert_manager ? 1 : 0
  name       = "cert-manager-resources"
  repository = "https://bedag.github.io/helm-charts/"
  chart      = "raw"
  version    = "2.0.0"
  namespace  = "cert-manager"
  values = [
    <<-EOF
    templates:
    - |
      apiVersion: cert-manager.io/v1
      kind: ClusterIssuer
      metadata:
        name: letsencrypt-prod
      spec:
        acme:
          server: https://acme-v02.api.letsencrypt.org/directory
          email: ${local.email}
          privateKeySecretRef:
            name: letsencrypt-prod
          solvers:
          - dns01:
              azureDNS:
                resourceGroupName: ${var.dns_zone_resource_group_name}
                subscriptionID: ${data.azurerm_subscription.current.subscription_id}
                hostedZoneName: ${var.domain_name}
                environment: AzurePublicCloud
                managedIdentity:
                  clientID: ${azurerm_user_assigned_identity.cert_manager[0].client_id}
    EOF
  ]
  depends_on = [
    helm_release.cert_manager
  ]
}

resource "azurerm_user_assigned_identity" "cert_manager" {
  count               = var.enable_cert_manager ? 1 : 0
  resource_group_name = data.azurerm_kubernetes_cluster.cluster.resource_group_name
  name                = "cert-manager"
  location            = var.location
}

resource "azurerm_role_assignment" "cert_manager_dns" {
  count                = var.enable_cert_manager ? 1 : 0
  scope                = data.azurerm_dns_zone.primary.id
  principal_id         = azurerm_user_assigned_identity.cert_manager[0].principal_id
  role_definition_name = "DNS Zone Contributor"
}

resource "azurerm_federated_identity_credential" "cert_manager" {
  count               = var.enable_cert_manager ? 1 : 0
  name                = azurerm_user_assigned_identity.cert_manager[0].name
  resource_group_name = azurerm_user_assigned_identity.cert_manager[0].resource_group_name
  parent_id           = azurerm_user_assigned_identity.cert_manager[0].id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = data.azurerm_kubernetes_cluster.cluster.oidc_issuer_url
  subject             = "system:serviceaccount:cert-manager:cert-manager"

  depends_on = [
    azurerm_role_assignment.cert_manager_dns
  ]
}
