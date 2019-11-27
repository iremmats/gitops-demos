resource "azurerm_resource_group" "purple" {
  name     = "Group-Purple"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "purple" {
  name                = "aks-purple"
  location            = azurerm_resource_group.purple.location
  resource_group_name = azurerm_resource_group.purple.name
  dns_prefix          = "purple"
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