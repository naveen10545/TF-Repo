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
    address_space=["10.0.0.0/22"]
    tags = {
        Environment = "Terraform Getting Started"
        Team = "DevOps"}
}

resource "azurerm_subnet" "subnet_thru_terraform" {
  name="terraformsubnet"
  resource_group_name = azurerm_resource_group.rg.name
  address_prefix ="10.0.1.0/24"
  virtual_network_name = azurerm_virtual_network.VNET_tru_terraform.name
}

resource "azurerm_subnet" "subnet_thru_terraform2" {
  name="terraformsubnet2"
  resource_group_name = azurerm_resource_group.rg.name
  address_prefix ="10.0.2.0/24"
  virtual_network_name = azurerm_virtual_network.VNET_tru_terraform.name
}


