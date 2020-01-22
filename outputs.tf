output "generic_RG" {
  value = azurerm_resource_group.genericRG.name
}

output "mainPublicIP" {
  value = azurerm_public_ip.mainPublicIP.ip_address
}

output "mainPrivateIP" {
  value = azurerm_network_interface.mainNIC.private_ip_address
}

output "sshAccess" {
  description = "Command to ssh into the VM."
  value       = <<SSHCONFIG
  ### ssh command to access the VM

  ssh ${var.vmUserName}@${azurerm_public_ip.mainPublicIP.ip_address} -i ${trimsuffix(var.sshKeyPath, ".pub")}

  ### commands to test the private end point.

  nslookup ${azurerm_storage_account.genericSA.name}.file.core.windows.net
  nslookup ${azurerm_storage_account.genericSA.name}.${azurerm_private_dns_zone.privateDNSZone.name}

  ### test if port 445 is open

  nc -zvw3 ${azurerm_storage_account.genericSA.name}.${azurerm_private_dns_zone.privateDNSZone.name} 445

  SSHCONFIG
}

output "private_endpoint_status" {
  value = data.azurerm_private_endpoint_connection.privateEndPointIP.private_service_connection.0.status
}

output "private_endpoint_private_ip_address" {
  value = data.azurerm_private_endpoint_connection.privateEndPointIP.private_service_connection.0.private_ip_address
}

output "publicEndPoint" {
  value = azurerm_storage_account.genericSA.primary_file_endpoint
}

output "privateEnPoint" {
  value = "${azurerm_storage_account.genericSA.name}.${azurerm_private_dns_zone.privateDNSZone.name}"
}

