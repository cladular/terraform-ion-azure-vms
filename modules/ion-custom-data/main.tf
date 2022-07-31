locals {
  service = templatefile("${path.module}/service.tpl", {
    service_name        = var.service_name
    service_description = var.service_description
    vm_user             = var.vm_user
  })
  custom_data = templatefile("${path.module}/custom-data.tpl", {
    ion_config     = var.ion_config
    ion_versioning = var.ion_versioning
    ion_service    = local.service
    vm_user        = var.vm_user
  })
}
