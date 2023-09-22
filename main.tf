
#Here is the resource group code
resource "azurerm_resource_group" "resource_storage" {
  name                     = var.resource_group_name
  location                 = var.resource_group_location
  
}


#Here is the storage account code
resource "azurerm_storage_account" "storage" {
  name = "storage${var.environment}function"
  resource_group_name      = azurerm_resource_group.resource_storage.name
  location                 = azurerm_resource_group.resource_storage.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication
  tags                     = {
    environment            = var.environment
  }
}


resource "azurerm_storage_container" "container" {
  name                     = "app-${var.environment}-function"
  storage_account_name     = azurerm_storage_account.storage.name
  container_access_type    = var.container_access_type
}


# resource "azurerm_storage_blob" "app_blob" {
#   name                     = "storage${var.environment}blob"
#   storage_account_name     = azurerm_storage_account.storage.name
#   storage_container_name   = azurerm_storage_container.container.name
#   type                     = var.blob_type
#   source                   = "C:/Users/David_Valero/Documents/Azure/Terraform/demo.zip"
  
# }