provider "azurerm" {
  version = "~>2.4.0"
  features {}


}
resource "azurerm_resource_group" "rg" {
        name = "groupforterraform"
        location = "westus"
}



resource "azurerm_virtual_network" "VNET_tru_terraform" {
    name ="terraformvnet"
    location="westus"
    resource_group_name = azurerm_resource_group.rg.name
    address_space=["1.0.0.0/22"]
    tags = {
        Environment = "Terraform Getting Started"
        Team = "DevOps"}
}

resource "azurerm_subnet" "subnet_thru_terraform" {
  name="terraformsubnet"
  resource_group_name = azurerm_resource_group.rg.name
  address_prefix ="1.0.1.0/24"
  virtual_network_name = azurerm_virtual_network.VNET_tru_terraform.name
}

resource "azurerm_subnet" "subnet_thru_terraform2" {
  name="terraformsubnet2"
  resource_group_name = azurerm_resource_group.rg.name
  address_prefix ="1.0.2.0/24"
  virtual_network_name = azurerm_virtual_network.VNET_tru_terraform.name
}


resource "azurerm_public_ip" "pip" {
  name                = "terraformpip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "pip2" {
  name                = "terraformpip2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}


resource "azurerm_network_interface" "nic" {
  name="terraformnic"
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  # network_security_group_id = azurerm_network_security_group.tfnsg.id

  ip_configuration{
    name="ipconfig"
    subnet_id                     = azurerm_subnet.subnet_thru_terraform.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}









resource "azurerm_network_interface" "nic2" {
  name = "terraformnic2"
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  # network_security_group_id = azurerm_network_security_group.tfnsg.id

  ip_configuration{
    name="ipconfig2"
    subnet_id                     = azurerm_subnet.subnet_thru_terraform2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip2.id
  }
}














resource "azurerm_network_security_group" "tfnsg" {
  name = "terraformnsg"
  location= azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "tf_nsg_rule" {
  name = "Inbound Rule"
  priority = 100
  direction = "Inbound"
  access = "Allow"
  protocol = "TCP"
  source_port_range = "*"
  destination_port_range = 3389
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.tfnsg.name
}

resource "azurerm_virtual_machine" "tf_virtual_machine" {
  name = "Terraform_VM"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_size = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.nic.id]
  # vnet_subnet_id      = [azurerm_virtual_network.VNET_tru_terraform.subnet[1]] 
  # virtual_network = azurerm_virtual_network.VNET_tru_terraform.name.subnet[0]
  
  

  storage_image_reference {
    publisher = "MicrosoftWindowsServer" 
    offer = "WindowsServer"
    sku = "2019-Datacenter"
    version = "latest"

  }

  storage_os_disk {
    name = "vmstorage"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile{
    computer_name = "osforvm"
    admin_username = "RakeshRoshan"
    admin_password = "RakeshRRO@1998"
  }

  os_profile_windows_config {
  }
}

resource "azurerm_virtual_machine" "tf_virtual_machineee" {
  name = "Terraform_VM2"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_size = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.nic2.id]
  # vnet_subnet_id      = [azurerm_virtual_network.VNET_tru_terraform.subnet[0]] 
  
  

  storage_image_reference {
    publisher = "MicrosoftWindowsServer" 
    offer = "WindowsServer"
    sku = "2019-Datacenter"
    version = "latest"

  }

  storage_os_disk {
    name = "vmstorage2"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile{
    computer_name = "osforvm2"
    admin_username = "RakeshRoshan"
    admin_password = "RakeshRRO@1998"
  }

  os_profile_windows_config {
  }
}