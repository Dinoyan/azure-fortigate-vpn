terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
			version = ">= 2.26"
		}
	}
}

provider "azurerm" {
	features {}
}

resource "azurerm_resource_group" "rg" {
	name = "vpn-site-to-site"
	location = "westus2"
}

resource "azurerm_virtual_network" "vnet" {
	name = "Main-Vnet"
	location = azurerm_resource_group.rg.location
	resource_group_name = azurerm_resource_group.rg.name
	address_space = ["10.10.0.0/24"]

	subnet {
	name = "GW-Subnet"
	address_prefix = "10.10.0.0/27"
	}
}

resource "azurerm_subnet" "gwsubnet" {
	name = "GatewaySubnet"
	resource_group_name = azurerm_resource_group.rg.name
	virtual_network_name = azurerm_virtual_network.vnet.name
	address_prefixes = ["10.10.0.32/28"]
}

resource "azurerm_public_ip" "pubip" {
	name = "gatway-pub-ip"
	location = azurerm_resource_group.rg.location
	resource_group_name = azurerm_resource_group.rg.name

	allocation_method = "Dynamic"
}

