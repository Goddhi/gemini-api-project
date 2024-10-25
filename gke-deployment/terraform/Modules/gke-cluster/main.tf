
data "google_client_config" "default" {}
provider "kubernetes" {
  host  = "https://${google_container_cluster.primary.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary-cluster.master_auth.0.cluster_ca_certificate)

}

resource "google_container_cluster" "primary-cluster" {
  name = var.cluster_name
  location = var.gke-zone

  # enable_autopilot = true

  network = var.vpc-name
  subnetwork = var.subnet-name
  
  

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_secondary_range_name = var.secondary-pods-range
    services_secondary_range_name = var.secondary-service-range
  }

  # datapath_provider = "ADVANCED_DATAPATH"  ### enabled dataplane v2

  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = false
    master_ipv4_cidr_block = var.master_ipv4_cidr_block

  }

  
  
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = var.authorized-network-ip
    }
  }
  release_channel {
    channel = var.channel-name
  }

}


resource "kubernetes_namespace" "gemini-api-namespace" {
  metadata {
    name = var.namespace
  }
}

resource "google_container_node_pool" "primary_node" {
  cluster = google_container_cluster.primary-cluster.name
  

  autoscaling {
    min_node_count = 0
    max_node_count = 1
  } 
   management {
    auto_repair  = true
    auto_upgrade = true
  }
  node_config {

    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb

    spot = true

    labels = {
      environment = var.environment
    }

    tags = [ var.network_tags ]
  }
}

