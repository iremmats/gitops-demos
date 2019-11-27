resource "azurerm_resource_group" "tools" {
  name     = "Group-Tools"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "tools" {
  name                = "aks-tools"
  location            = azurerm_resource_group.tools.location
  resource_group_name = azurerm_resource_group.tools.name
  dns_prefix          = "tols"
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