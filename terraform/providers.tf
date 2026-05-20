terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.7.0"
    }
    upcloud = {
      source  = "UpCloudLtd/upcloud"
      version = "5.37.0"
    }
  }
  backend "local" {
    path = "state/terraform.tfstate"
  }
}
