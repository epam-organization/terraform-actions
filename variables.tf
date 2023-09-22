
variable "environment" {
    default = "test"
    type = string
    description = "The name of lower environment"
}


variable "resource_group_name" {
    default = "azureFunction"
    type = string
    description = "The name of the Resource Group which contains the Storage Account"
}

variable "resource_group_location" {
    default = "East US"
    type = string
    description = "The Azure Region where the resources should be created"
}


variable "storage_account_tier" {
    default = "Standard"
    type = string
    description = "The tier type for the Storage Account"
}

variable "storage_account_replication" {
    default = "LRS"
    type = string
    description = "The replication type for the Storage Account"
}

variable "container_access_type" {
    default = "private"
    type = string
    description = "The container type for the Storage Account"
}

data "archive_file" "file_function_app"{
    type                           = "zip"
    source_dir                     = "../demo"
    output_path                    = "C:/Users/David_Valero/Documents/Azure/Terraform/azureFunction/demo.zip"
}

variable "archive_file" {
  
}

