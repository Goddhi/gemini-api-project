resource "google_compute_router" "router" {
    name = "${var.vpc-name}-router"
    network = google_compute_network.vpc-network.id
    region = var.region
}

