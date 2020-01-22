resource "azurerm_private_dns_zone" "privateDNSZone" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = azurerm_resource_group.genericRG.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "prvt_dns_zn_lnk" {
  name                  = "prvt_dns_zn_lnk"
  resource_group_name   = azurerm_resource_group.genericRG.name
  private_dns_zone_name = azurerm_private_dns_zone.privateDNSZone.name
  virtual_network_id    = azurerm_virtual_network.genericVNet.id
}

data "azurerm_private_endpoint_connection" "privateEndPointIP" {
  name                = azurerm_private_endpoint.privateEndPoint.name
  resource_group_name = azurerm_resource_group.genericRG.name
}

resource "azurerm_private_dns_a_record" "dnsRecord" {
  name                = var.storageAccountName
  zone_name           = azurerm_private_dns_zone.privateDNSZone.name
  resource_group_name = azurerm_resource_group.genericRG.name
  ttl                 = 300
  records             = ["${data.azurerm_private_endpoint_connection.privateEndPointIP.private_service_connection.0.private_ip_address}"]

  tags = var.tags
}
