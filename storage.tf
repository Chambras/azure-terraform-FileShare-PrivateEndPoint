resource "azurerm_storage_account" "genericSA" {
  name                     = var.storageAccountName
  resource_group_name      = azurerm_resource_group.genericRG.name
  location                 = azurerm_resource_group.genericRG.location
  account_kind             = var.saKind
  account_tier             = var.saTier
  account_replication_type = var.saReplicationType

  tags = var.tags
}

resource "azurerm_storage_share" "genericFileShare" {
  name                 = var.fsName
  storage_account_name = azurerm_storage_account.genericSA.name

  quota = var.fsQuota
}
