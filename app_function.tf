resource "azurerm_service_plan" "serviceplan" {
  name                             = "azure-functions-${var.environment}-service-plan"
  location                         = azurerm_resource_group.resource_storage.location
  resource_group_name              = azurerm_resource_group.resource_storage.name
  os_type                          = "Windows"
  sku_name                         = "Y1" 
}



resource "azurerm_windows_function_app" "appFunction" {
  name                             = "${var.environment}-function-dotnet"
  resource_group_name              = azurerm_resource_group.resource_storage.name
  location                         = azurerm_resource_group.resource_storage.location
  storage_account_name             = azurerm_storage_account.storage.name
  storage_account_access_key       = azurerm_storage_account.storage.primary_access_key
  service_plan_id                  = azurerm_service_plan.serviceplan.id

  # app_settings={
  #   # WEBSITE_RUN_FROM_PACKAGE       = "https://storagetestfunction.blob.core.windows.net/app-test-function/HttpTrigger.zip?sp=r&st=2023-09-19T00:53:44Z&se=2023-09-19T08:53:44Z&sv=2022-11-02&sr=b&sig=B%2F8phbTrQFlu3vNtEDcel8S%2FCHgFit%2Bk9pQiA59oHns%3D"    
  #   WEBSITE_RUN_FROM_PACKAGE       = "1"    
  #   FUNCTIONS_WORKER_RUNTIME       = "dotnet-isolated"
  #   "FUNCTIONS_EXTENSION_VERSION"  = "6.0"
  #   AzureWebJobsDisableHomepage    = "true"
  #   SCM_DO_BUILD_DURING_DEPLOYMENT =  "true"
  # }

  site_config {
    # linux_fx_version               = "DOCKER|mcr.microsoft.com/azure-functions/python:3.0-python3.11"        
  }
  depends_on = [ 
    azurerm_storage_account.storage 
    ]
  
  identity {
    type                           = "SystemAssigned"
  } 
}


locals {    
    # publish_code_command           = "az functionapp deployment source config-zip --resource-group ${var.resource_group_name} --name ${azurerm_windows_function_app.appFunction.name} --src ${data.archive_file.file_function_app.output_path}"
    publish_code_command            = "az functionapp deploy --resource-group ${var.resource_group_name} --name ${azurerm_windows_function_app.appFunction.name} --src-path ${data.archive_file.file_function_app.output_path} --type zip --async true"            
    # publish_code_command             = "az functionapp create --resource-group ${var.resource_group_name} --name ${azurerm_windows_function_app.appFunction.name} --storage-account ${azurerm_storage_account.storage.name} --os-type Windows --runtime dotnet --consumption-plan-location eastus --functions-version 3"
}

resource "null_resource" "function_app_publish" {
  provisioner "local-exec" {
    command                        = local.publish_code_command
  }
  depends_on                       = [ azurerm_windows_function_app.appFunction, local.publish_code_command ]
  triggers = {
    input_json                     = filemd5(data.archive_file.file_function_app.output_path)        
    publish_code_command           = local.publish_code_command
  }
}

# output "function_app_default_hostname" {
#   value                            = azurerm_linux_function_app.appFunction.default_hostname
#   depends_on                       = [ null_resource.function_app_publish ]
# }

