resource "azurerm_public_ip" "this" {
  name                = "pip-${var.deployment_name}-${var.service_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "this" {
  name                = "nsg-${var.deployment_name}-${var.service_name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "this" {
  name                = "nic-${var.deployment_name}-${var.service_name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipc-${var.deployment_name}-${var.service_name}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_linux_virtual_machine" "this" {
  name                  = "vm-${var.deployment_name}-${var.service_name}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.this.id]
  size                  = "Standard_L8s_v2"
  custom_data           = base64encode(var.custom_data)

  os_disk {
    name                 = "disk-${var.deployment_name}-${var.service_name}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "vm-${var.deployment_name}-${var.service_name}"
  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = "${var.deployment_name}user"
    public_key = var.ssh_public_key
  }
}
