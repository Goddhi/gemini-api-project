
data "google_client_config" "default" {}
provider "kubernetes" {
  host  = "https://${google_container_cluster.primary-cluster.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary-cluster.master_auth.0.cluster_ca_certificate)

}

resource "google_container_cluster" "primary-cluster" {
  name = var.cluster_name
  location = var.gke-zone

  # enable_autopilot = true

  network = var.vpc-name
  subnetwork = var.subnet-name
  
  
  deletion_protection = false
  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_secondary_range_name = var.pod-range-name
    services_secondary_range_name = var.secondary_ip_range_services_name
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

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  workload_identity_config {
    workload_pool = "${var.project-id}.svc.id.goog"
  }

}


resource "kubernetes_namespace" "gemini-api-namespace" {
  metadata {
    name = var.namespace
  }
}

resource "google_service_account" "workload_svc" {
  account_id = var.account_id
  display_name = var.svc_display_name
  project = var.project-id
}

resource "google_project_iam_member" "gemini_app_roles" {
  for_each = toset([
    "roles/logging.logWriter"
  ])

  role = each.key
  member = "serviceAccount:${google_service_account.service_account.email}"
  project = var.project-id
}

resource "kubernetes_service_account" "ksa" {
  metadata {
    name = var.ksa
    namespace = var.namespace
    annotations = {
            "iam.gke.io/gcp-service-account" = google_service_account.workload_svc.email
    }
  }

  depends_on = [ google_container_cluster.primary-cluster, google_container_node_pool.primary_node]
}

resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.workload_svc.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project-id}.svc.id.goog[${var.namespace}/${kubernetes_service_account.ksa.metadata[0].name}]"
  ]
}

resource "google_container_node_pool" "primary_node" {
  cluster = google_container_cluster.primary-cluster.name
  location = var.gke-zone
  

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

    #     oauth_scopes = [
    #   "https://www.googleapis.com/auth/logging.write",
    #   "https://www.googleapis.com/auth/devstorage.read_only",
    #   "https://www.googleapis.com/auth/service.management.readonly",
    #   "https://www.googleapis.com/auth/servicecontrol",
    # ]

    # tags = [ var.network_tags ]
  }
  depends_on = [ google_container_cluster.primary-cluster ]
}
 