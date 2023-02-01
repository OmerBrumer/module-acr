module "acr" {
  source = "../../../app/acr"

  resource_group_name = "brumer-final-terraform-hub-rg"
  location            = "West Europe"
  subnet_id           = "/subscriptions/xxxxx/resourceGroups/brumer-final-terraform-hub-rg/providers/Microsoft.Network/virtualNetworks/brumer-final-terraform-hub-vnet/subnets/EndpointSubnet"

  container_registry_config = {
    name                      = "brumer-final-terraform-hub-acr"
    admin_enabled             = false
    sku                       = false
    quarantine_policy_enabled = false
    zone_redundancy_enabled   = false
  }

  georeplications = {
    location                = "East US"
    zone_redundancy_enabled = true
  }

  network_rule_set = {
    ip_range = "11.11.0.0/24"
  }

  retention_policy = {
    days    = 10
    enabled = true
  }

  trust_policy = {
    enable_content_trust = false
  }

  encryption = {
    enabled = false
  }

  enable_content_trust       = true
  log_analytics_workspace_id = "/subscriptions/d94fe338-52d8-4a44-acd4-4f8301adf2cf/resourcegroups/brumer-final-terraform-hub-rg/providers/microsoft.operationalinsights/workspaces/brumer-final-terraform-hub-log-analytics"
  subresource_name           = "registry"
  private_dns_zone_ids = [
    "/subscriptions/d94fe338-52d8-4a44-acd4-4f8301adf2cf/resourceGroups/brumer-final-terraform-hub-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"
  ]
}