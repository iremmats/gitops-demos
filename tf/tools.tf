resource "azurerm_resource_group" "tools" {
  name     = "Group-Tools"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "tools" {
  name                = "aks-tools"
  location            = azurerm_resource_group.tools.location
  resource_group_name = azurerm_resource_group.tools.name
  dns_prefix          = "tols"
  kubernetes_version  = "1.16.7"

  default_node_pool {
    name            = "extra"
    min_count       = 1
    max_count       = 10
    node_count      = 1
    enable_auto_scaling = true
    vm_size         = "Standard_D4s_v3"
    os_disk_size_gb = 30
    max_pods        = 30
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    environment = "demo"
  }
}