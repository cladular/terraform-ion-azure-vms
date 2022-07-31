variable "location" {
  type = string
}

variable "deployment_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "service_name" {
  type = string
}

variable "custom_data" {
  type      = string
  sensitive = true
}

variable "admin_username" {
  type = string
}
