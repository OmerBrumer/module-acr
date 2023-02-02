/**
* # Azure Container Registry with Private Endpoint and Diagnostic Setting module
*/

resource "azurerm_container_registry" "main" {
  name                          = var.container_registry_config.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  admin_enabled                 = var.container_registry_config.admin_enabled
  sku                           = var.container_registry_config.sku
  quarantine_policy_enabled     = var.container_registry_config.quarantine_policy_enabled
  zone_redundancy_enabled       = var.container_registry_config.zone_redundancy_enabled
  public_network_access_enabled = false

  dynamic "georeplications" {
    for_each = var.georeplications

    content {
      location                = georeplications.value.location
      zone_redundancy_enabled = georeplications.value.zone_redundancy_enabled
    }
  }

  dynamic "network_rule_set" {
    for_each = var.network_rule_set == null ? [] : [var.network_rule_set]

    content {
      default_action = lookup(network_rule_set.value, "default_action", "Allow")

      dynamic "ip_rule" {
        for_each = network_rule_set.value.ip_rule

        content {
          action   = "Allow"
          ip_range = ip_rule.value.ip_range
        }
      }

      dynamic "virtual_network" {
        for_each = network_rule_set.value.virtual_network

        content {
          action    = "Allow"
          subnet_id = virtual_network.value.subnet_id
        }
      }
    }
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy == null ? [] : [var.retention_policy]

    content {
      days    = lookup(retention_policy.value, "days", 7)
      enabled = lookup(retention_policy.value, "enabled", true)
    }
  }

  dynamic "trust_policy" {
    for_each = var.enable_content_trust ? [var.enable_content_trust] : []

    content {
      enabled = var.enable_content_trust
    }
  }

  identity {
    type         = var.identity_type
    identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned, UserAssigned" ? var.identity_ids : null
  }

  dynamic "encryption" {
    for_each = var.encryption == null ? [] : [var.encryption]

    content {
      enabled            = true
      key_vault_key_id   = encryption.value.key_vault_key_id
      identity_client_id = encryption.value.identity_client_id
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

module "private_endpoint" {
  source = "git::https://github.com/OmerBrumer/module-private-endpoint.git?ref=dev"

  private_endpoint_name          = "${var.container_registry_config.name}-private-endpoint"
  resource_group_name            = var.resource_group_name
  location                       = var.location
  private_connection_resource_id = azurerm_container_registry.main.id
  subnet_id                      = var.subnet_id
  subresource_name               = var.subresource_name
  private_dns_zone_ids           = var.private_dns_zone_ids
}

module "diagnostic_settings" {
  source = "git::https://github.com/OmerBrumer/module-diagnostic-setting.git?ref=dev"

  diagonstic_setting_name    = "${azurerm_container_registry.main.name}-diagnostic-setting"
  log_analytics_workspace_id = var.log_analytics_workspace_id
  target_resource_id         = azurerm_container_registry.main.id
}