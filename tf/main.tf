provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "1.36.0"
  tenant_id = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
}