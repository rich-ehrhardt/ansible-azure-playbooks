variable "resource_group_name" {
  description = "Name of the resource group for the resources"
}

variable "my_ip_address" {
  description = "Internet IP address to use for access"
}

# variable "subscription_id" {
#   description = "Subscription id to use"
# }

# variable "tenant_id" {
#  description = "Tenant for the login" 
# }

# variable "client_id" {
#   description = "Service principal id to use for login"
# }

# variable "client_secret" {
#   description = "Service principal secret"
# }

variable "location" {
  description = "Location for the resources"
  default = "australiaeast"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  default = "vnet"
}

variable "vnet_cidr" {
  description = "Network address of the virtual network"
  default = "10.0.0.0/20"
}

variable "subnet_name" {
  description = "Subnet name"
  default = "vm-subnet"
}

variable "subnet_cidr" {
  description = "Network address of the subnet"
  default = "10.0.0.0/24"
}

variable "nsg_name" {
  description = "Network security group name"
  default = "vm-nsg"
}

variable "public_ip_name" {
  description = "Name of the public IP resource"
  default = "vm-pip"
}

variable "vm_name" {
  description = "Name of the virtual machine resource"
  default = "build-vm"
}

variable "vm_size" {
  description = "Virtual machine size"
  default = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  default = "azureuser"
}

variable "ssh_key_path" {
  description = "Path to the public SSH key to use to virtual machine access"
  default = "~/.ssh/id_rsa.pub"
}

variable "image_publisher" {
  description = "VM image publisher"
  default = "Canonical"
}

variable "image_offer" {
  description = "VM image offer"
  default = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "VM image SKU"
  default = "22_04-lts"
}

variable "image_version" {
  description = "VM image description"
  default = "latest"
}