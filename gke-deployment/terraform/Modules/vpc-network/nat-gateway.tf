resource "google_compute_router_nat" "nat-gateway" {
  name = "${var.vpc-name}-nat-gateway"
  router = google_compute_router.router.id
  region = var.region
  nat_ip_allocate_option = var.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat


  depends_on = [
    google_compute_network.vpc-network
  ]
  
}