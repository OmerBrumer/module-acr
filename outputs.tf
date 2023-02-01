output "id" {
  description = "Id of acr."
  value       = azurerm_container_registry.main.id
}

output "name" {
  description = "Name of acr."
  value       = azurerm_container_registry.main.name
}

output "object" {
  description = "Object of acr."
  value       = azurerm_container_registry.main
}