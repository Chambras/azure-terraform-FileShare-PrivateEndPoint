## Create Network
resource "azurerm_virtual_network" "genericVNet" {
  name                = "${var.suffix}${var.vnetName}"
  location            = azurerm_resource_group.genericRG.location
  resource_group_name = azurerm_resource_group.genericRG.name
  address_space       = ["${local.base_cidr_block}"]

  tags = var.tags
}

resource "azurerm_subnet" "private" {
  name                 = "private"
  resource_group_name  = azurerm_resource_group.genericRG.name
  virtual_network_name = azurerm_virtual_network.genericVNet.name
  address_prefix       = "10.70.0.0/24"

  enforce_private_link_endpoint_network_policies = true

  # work around for https://github.com/terraform-providers/terraform-provider-azurerm/issues/2358
  lifecycle {
    ignore_changes = [network_security_group_id, route_table_id]
  }
}

resource "azurerm_subnet_network_security_group_association" "NSGAssociation" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.genericNSG.id
}

resource "azurerm_private_endpoint" "privateEndPoint" {
  name                = "fileshare"
  location            = azurerm_resource_group.genericRG.location
  resource_group_name = azurerm_resource_group.genericRG.name
  subnet_id           = azurerm_subnet.private.id

  private_service_connection {
    name                           = "StorageConnection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.genericSA.id
    subresource_names              = ["file"]
  }
}
