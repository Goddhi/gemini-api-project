output "network_id" {
  value = google_compute_network.vpc-network.id
  description = "id of the vpc network"
}

output "subnet_id" {
    description = " the id of the subnet"
    value = google_compute_subnetwork.vpc-private-subnet.id
}

output "secondary_ip_range_services_name" {
  value = google_compute_subnetwork.vpc-private-subnet.secondary_ip_range[0].range_name
}

output "secondary-service-range" {
  value = google_compute_subnetwork.vpc-private-subnet.secondary_ip_range[0].ip_cidr_range
}

output "secondary_ip_range_pods_name" {
  value = google_compute_subnetwork.vpc-private-subnet.secondary_ip_range[1].range_name
}

output "secondary-pods-range" {
  value = google_compute_subnetwork.vpc-private-subnet.secondary_ip_range[1].ip_cidr_range
}

output "network_tags" {
 value = google_compute_firewall.allow_internal.target_tags
}