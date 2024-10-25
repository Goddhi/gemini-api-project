resource "google_compute_network" "vpc-network" {
  name =  var.vpc-name
  auto_create_subnetworks = false
  routing_mode = var.routing-mode
}

resource "google_compute_subnetwork" "vpc-private-subnet" {
  name = "${var.vpc-name}-private-subnet"
  network = google_compute_network.vpc-network.id
  ip_cidr_range = var.ip_cidr_range
  region = var.region
  

  private_ip_google_access = true

  secondary_ip_range {
    range_name = var.secondary_ip_range_pods_name
    ip_cidr_range = var.secondary-pods-range
  }

  secondary_ip_range {
    range_name = var.secondary_ip_range_services_name
    ip_cidr_range = var.secondary-service-range
  }
  
  
}

