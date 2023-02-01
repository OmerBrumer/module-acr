<!-- BEGIN_TF_DOCS -->

# Azure Container Registry with Private Endpoint and Diagnostic Setting module

## Examples
```hcl
module "acr" {
  source = "../../../app/acr"

  resource_group_name = "brumer-final-terraform-hub-rg"
  location            = "West Europe"
  subnet_id           = "/subscriptions/d94fe338-52d8-4a44-acd4-4f8301adf2cf/resourceGroups/brumer-final-terraform-hub-rg/providers/Microsoft.Network/virtualNetworks/brumer-final-terraform-hub-vnet/subnets/EndpointSubnet"

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
```

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Id of acr. |
| <a name="output_name"></a> [name](#output\_name) | Name of acr. |
| <a name="output_object"></a> [object](#output\_object) | Object of acr. |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_registry_config"></a> [container\_registry\_config](#input\_container\_registry\_config) | (Required)Manages an Azure Container Registry. | <pre>object({<br>    name                      = string<br>    admin_enabled             = optional(bool, false)<br>    sku                       = optional(string)<br>    quarantine_policy_enabled = optional(bool)<br>    zone_redundancy_enabled   = optional(bool, false)<br>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required)The location to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required)A container that holds related resources for an Azure solution. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Required)Id of subnet to associate with the acr. | `string` | n/a | yes |
| <a name="input_subresource_name"></a> [subresource\_name](#input\_subresource\_name) | (Required)Name of the subresource corresponding to the target Azure resource. Only valid if `target_resource` is not a Private Link Service. | `string` | n/a | yes |
| <a name="input_enable_content_trust"></a> [enable\_content\_trust](#input\_enable\_content\_trust) | (Optional)Boolean value to enable or disable Content trust in Azure Container Registry. | `bool` | `false` | no |
| <a name="input_encryption"></a> [encryption](#input\_encryption) | (Optional)Encrypt registry using a customer-managed key. | <pre>object({<br>    key_vault_key_id   = string<br>    identity_client_id = string<br>  })</pre> | `null` | no |
| <a name="input_georeplications"></a> [georeplications](#input\_georeplications) | (Optional)A list of Azure locations where the container registry should be geo-replicated. | <pre>list(object({<br>    location                = string<br>    zone_redundancy_enabled = optional(bool, false)<br>  }))</pre> | `[]` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | (Optional)Specifies a list of user managed identity ids to be assigned. This is required when `type` is set to `UserAssigned` or `SystemAssigned, UserAssigned`. | `list(string)` | `null` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | (Required)Log analytics workspace id to send logs from the current resource. | `string` | `null` | no |
| <a name="input_network_rule_set"></a> [network\_rule\_set](#input\_network\_rule\_set) | (Optional)Manage network rules for Azure Container Registries. | <pre>object({<br>    default_action = optional(string)<br>    ip_rule = optional(list(object({<br>      ip_range = string<br>    })))<br>    virtual_network = optional(list(object({<br>      subnet_id = string<br>    })))<br>  })</pre> | `null` | no |
| <a name="input_private_dns_zone_ids"></a> [private\_dns\_zone\_ids](#input\_private\_dns\_zone\_ids) | (Optional)Specifies the list of Private DNS Zones to include within the private\_dns\_zone\_group. | `list(string)` | `[]` | no |
| <a name="input_retention_policy"></a> [retention\_policy](#input\_retention\_policy) | (Optional)Set a retention policy for untagged manifests. | <pre>object({<br>    days    = optional(number)<br>    enabled = optional(bool)<br>  })</pre> | `null` | no |



# Authors
Originally created by Omer Brumer
<!-- END_TF_DOCS -->