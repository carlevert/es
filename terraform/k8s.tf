locals {
  name = "dev"
  zone = "se-sto1"
  network_address = "10.99.0.0/24"
}

resource "upcloud_router" "this" {
  name = local.name
  lifecycle {
    ignore_changes = [static_route]
  }
}

resource "upcloud_network" "this" {
  name = local.name
  zone = local.zone
  ip_network {
    address            = local.network_address
    dhcp               = true
    dhcp_default_route = true
    family             = "IPv4"
  }
  router = upcloud_router.this.id
}

resource "upcloud_gateway" "this" {
  features = ["nat"]
  name = local.name
  plan = "development"
  zone = local.zone
  router {
    id = upcloud_router.this.id
  }
}

resource "upcloud_kubernetes_cluster" "this" {
  control_plane_ip_filter = ["0.0.0.0/0"]
  name                    = local.name
  network                 = upcloud_network.this.id
  plan                    = "dev-md"
  private_node_groups     = true
  version                 = "1.35"
  upgrade_strategy_type   = "manual"
  zone                    = local.zone
}

resource "upcloud_kubernetes_node_group" "this" {
  cluster    = upcloud_kubernetes_cluster.this.id
  name       = local.name
  node_count = 2
  plan       = "CLOUDNATIVE-2xCPU-16GB"
  ssh_keys   = [file("${path.module}/carlevert-260301.pub")]
  cloud_native_plan {
    storage_size = 20
    storage_tier = "maxiops"
  }
  anti_affinity = false
}

data "upcloud_kubernetes_cluster" "this" {
  id = upcloud_kubernetes_cluster.this.id
}

resource "local_file" "kubeconfig" {
  filename = "${path.module}/kubeconfig.yaml"
  content  = data.upcloud_kubernetes_cluster.this.kubeconfig
}
