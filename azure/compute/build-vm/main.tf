terraform {
  required_version = ">= 0.15.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}

  # subscription_id = var.subscription_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  # tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
  location = var.location
}

resource "azurerm_network_security_group" "nsg" {
  name = var.nsg_name
  location = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name = "AllowSSHfromMyIP"
  resource_group_name = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.nsg.name
  
  priority = 100
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "22"
  source_address_prefix = var.my_ip_address
  destination_address_prefix = "VirtualNetwork"
}

resource "azurerm_virtual_network" "vnet" {
  name  = var.vnet_name
  location = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space = [ var.vnet_cidr ]
}

resource "azurerm_subnet" "vm_subnet" {
  name = var.subnet_name
  resource_group_name = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [ var.subnet_cidr ]
}

resource "azurerm_public_ip" "vm_pip" {
  name = var.public_ip_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location = azurerm_resource_group.resource_group.location
  allocation_method = "Static"
}

resource "azurerm_network_interface" "vm_nic" {
  name = "vm-nic"
  location = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name = "public"
    primary = "true"
    subnet_id = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version = "IPv4"
    public_ip_address_id = azurerm_public_ip.vm_pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "vm_nsg_association" {
  network_interface_id = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "build_vm" {
  name = var.vm_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location = azurerm_resource_group.resource_group.location
  size = var.vm_size
  admin_username = var.admin_username

  network_interface_ids = [ 
    azurerm_network_interface.vm_nic.id
    ]
  
  admin_ssh_key {
    username = var.admin_username
    public_key = file(var.ssh_key_path)
  }

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer = var.image_offer
    sku = var.image_sku
    version = var.image_version
  }
}

