terraform {
}

# NOTE: I have create a file called provider.tf and moded the below section in that file.
# az ad sp create-for-rbac --name spterraform --role Contributor
#provider "azurerm" {
#  features {}
#  subscription_id   = "xxxx"
#  tenant_id         = "xxxx"
#  client_id         = "xxxx"
#  client_secret     = "xxxx"
#}

resource "azurerm_resource_group" "rg-kv" {
  location = "eastus"
  name     = "rg-kv"
}

resource "azurerm_key_vault" "azkv00100" {
  location            = azurerm_resource_group.rg-kv.location
  name                = "azkv00100"
  resource_group_name = azurerm_resource_group.rg-kv.name
  sku_name            = "standard"
  tenant_id           = "ecf31552-6c73-4ac3-8201-1a4ef286370f"
}

#  application_id = "e5e87b0f-2cc1-46e0-a955-87ca332a1be9"
resource "azurerm_key_vault_access_policy" "ap" {
  key_vault_id = azurerm_key_vault.azkv00100.id
  tenant_id = "ecf31552-6c73-4ac3-8201-1a4ef286370f"
  object_id = "557aaa68-8d67-4814-9aa6-6ddc87fa5b87"
  key_permissions    = ["get", "create", "list", "restore", "recover", "unwrapkey", "wrapkey", "purge", "encrypt", "decrypt", "sign", "verify"]
  secret_permissions = ["get", "delete", "list"]
}

resource "azurerm_key_vault_access_policy" "apuser" {
  key_vault_id = azurerm_key_vault.azkv00100.id
  tenant_id = "ecf31552-6c73-4ac3-8201-1a4ef286370f"
  object_id = "8c22dfae-adfa-4388-ac1f-975b54a9a475"
  key_permissions    = ["get", "create", "list", "restore", "recover", "unwrapkey", "wrapkey", "purge", "encrypt", "decrypt", "sign", "verify"]
  secret_permissions = ["get", "delete", "list", "set"]
}
