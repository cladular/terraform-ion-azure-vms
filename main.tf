provider "azurerm" {
  features {}
}

locals {
  deployment_name = "ionnode"
  location        = "eastus"
  admin_username  = "${local.deployment_name}user"
  ion_bitcoin_config = templatefile("${path.module}/bitcoin-config.tpl", {
    bitcoin_host     = var.bitcoin_host
    bitcoin_user     = var.bitcoin_user
    bitcoin_password = var.bitcoin_password
    bitcoin_wallet   = var.bitcoin_wallet
    mongo_uri        = var.mongo_uri
  })
  ion_core_config = templatefile("${path.module}/core-config.tpl", {
    ion_bitcoin_host = module.bitcoin_vm.public_ip
    ipfs_host        = var.ipfs_host
    mongo_uri        = var.mongo_uri
  })
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${local.deployment_name}-${local.location}"
  location = local.location
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-${local.deployment_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "this" {
  name                 = "snet-${local.deployment_name}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "this" {
  content  = tls_private_key.this.private_key_pem
  filename = "${path.cwd}/ssh.pem"
}

module "bitcoin_custom_data" {
  source = "./modules/ion-custom-data"

  service_name        = "bitcoin"
  service_description = "ION Bitcoin Service"
  vm_user             = local.admin_username
  ion_versioning      = file("${path.module}/bitcoin-versioning.tpl")
  ion_config          = local.ion_bitcoin_config
}

module "bitcoin_vm" {
  source = "./modules/ion-vm"

  location            = local.location
  deployment_name     = local.deployment_name
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = azurerm_subnet.this.id
  ssh_public_key      = tls_private_key.this.public_key_openssh
  service_name        = "bitcoin"
  custom_data         = module.bitcoin_custom_data.custom_data
  admin_username      = local.admin_username
}

module "core_custom_data" {
  source = "./modules/ion-custom-data"

  service_name        = "core"
  service_description = "ION Core Service"
  vm_user             = local.admin_username
  ion_versioning      = file("${path.module}/core-versioning.tpl")
  ion_config          = local.ion_core_config
}

module "core_vm" {
  source = "./modules/ion-vm"

  location            = local.location
  deployment_name     = local.deployment_name
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = azurerm_subnet.this.id
  ssh_public_key      = tls_private_key.this.public_key_openssh
  service_name        = "core"
  custom_data         = module.core_custom_data.custom_data
  admin_username      = local.admin_username
}
