output "ion_bitcoin_public_ip" {
  value = module.bitcoin_vm.public_ip
}

output "ion_core_public_ip" {
  value = module.core_vm.public_ip
}

output "admin_username" {
  value = local.admin_username
}
