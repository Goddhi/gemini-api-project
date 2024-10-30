resource "google_compute_firewall" "allow_internal" {
  name = "${var.vpc-name}-external-firewal-rule"
  network = google_compute_network.vpc-network.id

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports = var.allowed_ports

  }

  source_ranges = var.internal_source_ranges

      depends_on = [
    google_compute_network.vpc-network
  ]

  # target_tags = [ var.network_tags ] 
}
  