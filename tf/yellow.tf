resource "azurerm_resource_group" "yellow" {
  name     = "Group-Yellow"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "yellow" {
  name                = "aks-yellow"
  location            = azurerm_resource_group.yellow.location
  resource_group_name = azurerm_resource_group.yellow.name
  dns_prefix          = "yellow"
  kubernetes_version  = "1.14.8"

  agent_pool_profile {
    name            = "extra"
    count           = 2
    vm_size         = "Standard_D2s_v3"
    os_type         = "Linux"
    os_disk_size_gb = 30
    max_pods        = 30
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  tags = {
    environment = "demo"
  }
}