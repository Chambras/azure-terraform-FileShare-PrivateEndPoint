resource "azurerm_public_ip" "mainPublicIP" {
  name                = "${var.suffix}-mainPublicIP"
  location            = azurerm_resource_group.genericRG.location
  resource_group_name = azurerm_resource_group.genericRG.name
  allocation_method   = "Static"

  tags = var.tags
}

resource "azurerm_network_interface" "mainNIC" {
  name                      = "${var.suffix}-mainNIC"
  location                  = azurerm_resource_group.genericRG.location
  resource_group_name       = azurerm_resource_group.genericRG.name
  network_security_group_id = azurerm_network_security_group.genericNSG.id

  ip_configuration {
    name                          = "mainServer"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mainPublicIP.id
  }

  tags = var.tags
}

resource "azurerm_virtual_machine" "mainServer" {
  name                  = "${var.suffix}-mainServer"
  location              = azurerm_resource_group.genericRG.location
  resource_group_name   = azurerm_resource_group.genericRG.name
  network_interface_ids = ["${azurerm_network_interface.mainNIC.id}"]
  vm_size               = var.vmSize

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7-RAW-CI"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.suffix}-mainServerosDisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "mainServer"
    admin_username = var.vmUserName
    custom_data    = <<-EOF
    #cloud-config
    package_upgrade: true
    packages:
      - cifs-utils
      - nc
    EOF
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.vmUserName}/.ssh/authorized_keys"
      key_data = file("~/.ssh/vm_ssh.pub")
    }
  }
  tags = var.tags
}
