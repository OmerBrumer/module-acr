variable "resource_group_name" {
  description = "(Required)A container that holds related resources for an Azure solution."
  type        = string
}

variable "location" {
  description = "(Required)The location to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'."
  type        = string
}

variable "container_registry_config" {
  description = <<EOF
    (Required)Manages an Azure Container Registry
    name = (Required)Specifies the name of the Container Registry. Only Alphanumeric characters allowed. Changing this forces a new resource to be created.
    admin_enabled = (Optional)Specifies whether the admin user is enabled. Defaults to false.
    sku = (Required)The SKU name of the container registry. Possible values are Basic, Standard and Premium.
    quarantine_policy_enabled = (Optional)Boolean value that indicates whether quarantine policy is enabled.
    zone_redundancy_enabled = (Optional)Whether zone redundancy is enabled for this Container Registry? Changing this forces a new resource to be created. Defaults to false.
  EOF
  type = object({
    name                      = string
    admin_enabled             = optional(bool, false)
    sku                       = string
    quarantine_policy_enabled = optional(bool)
    zone_redundancy_enabled   = optional(bool, false)
  })
}

variable "subnet_id" {
  description = "(Required)Id of subnet to associate with the acr."
  type        = string
}

variable "identity_type" {
  description = "(Optional)The type of identity used for the managed cluster. Conflict with `client_id` and `client_secret`. Possible values are `SystemAssigned` or `UserAssigned`. If `UserAssigned` is set, an `identity_ids` must be set as well."
  type        = string
  default     = "SystemAssigned"

  validation {
    condition     = var.identity_type == "SystemAssigned" || var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned, UserAssigned"
    error_message = "`identity_type`'s possible values are `SystemAssigned`, `UserAssigned` or 'SystemAssigned, UserAssigned'."
  }
}

variable "georeplications" {
  description = "(Optional)A list of Azure locations where the container registry should be geo-replicated."
  type = list(object({
    location                = string
    zone_redundancy_enabled = optional(bool, false)
  }))
  default = []
}

variable "subresource_name" {
  description = "(Optional)Name of the subresource corresponding to the target Azure resource. Only valid if `target_resource` is not a Private Link Service."
  type        = string
  default     = "registry"
}


variable "network_rule_set" {
  description = "(Optional)Manage network rules for Azure Container Registries."
  type = object({
    default_action = optional(string)
    ip_rule = optional(list(object({
      ip_range = string
    })))
    virtual_network = optional(list(object({
      subnet_id = string
    })))
  })
  default = null
}

variable "retention_policy" {
  description = "(Optional)Set a retention policy for untagged manifests."
  type = object({
    days    = optional(number)
    enabled = optional(bool)
  })
  default = null
}

variable "enable_content_trust" {
  description = "(Optional)Boolean value to enable or disable Content trust in Azure Container Registry."
  type        = bool
  default     = false
}

variable "identity_ids" {
  description = "(Optional)Specifies a list of user managed identity ids to be assigned. This is required when `type` is set to `UserAssigned` or `SystemAssigned, UserAssigned`."
  type        = list(string)
  default     = null
}

variable "encryption" {
  description = "(Optional)Encrypt registry using a customer-managed key."
  type = object({
    key_vault_key_id   = string
    identity_client_id = string
  })
  default = null
}

variable "log_analytics_workspace_id" {
  description = "(Required)Log analytics workspace id to send logs from the current resource."
  type        = string
}


variable "private_dns_zone_ids" {
  description = "(Optional)Specifies the list of Private DNS Zones to include within the private_dns_zone_group."
  type        = list(string)
  default     = []
}