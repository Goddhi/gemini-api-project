

module "vpc-network" {
  source = "./Modules/vpc-network"
  project-id = var.project-id
  vpc-name = var.vpc-name
  region = var.region
  routing-mode = var.routing_mode
  secondary_ip_range_services_name = var.secondary_ip_range_services_name
  secondary_ip_range_pods_name = var.secondary_ip_range_pods_name
  secondary-pods-range = var.secondary-pods-range
  secondary-service-range = var.secondary-service-range
  internal_source_ranges = var.internal_source_ranges
  allowed_ports = var.allowed_ports
  ip_cidr_range = var.ip_cidr_range 
  # network_tags = var.network_tags
   
}

module "gke-cluster" {
  source = "./Modules/gke-cluster"
  secondary-pods-range = module.vpc-network.secondary-pods-range
  secondary-service-range = module.vpc-network.secondary-service-range
  pod-range-name = module.vpc-network.secondary_ip_range_pods_name
  secondary_ip_range_services_name = module.vpc-network.secondary_ip_range_services_name
  subnet-name = module.vpc-network.subnet_id
  vpc-name = module.vpc-network.network_id
  cluster_name = var.cluster_name
  gke-zone = var.gke-zone
  namespace = var.namespace
  channel-name = var.channel-name
  master_ipv4_cidr_block = var.master_ipv4_cidr_block
  authorized-network-ip = var.authorized-network-ip
  machine_type = var.machine_type
  disk_size_gb = var.disk_size_gb
  environment = var.environment
  # network_tags = module.vpc-network.network_tags
  project-id = var.project-id
  account_id = var.account_id
  svc_display_name = var.svc_display_name
  ksa = var.ksa

}

# resource "google_project_service" "apis" {
#   for_each = toset([
#     "cloudresourcemanager.googleapis.com",
#     "container.googleapis.com",
#     "containersecurity.googleapis.com",
#     "artifactregistry.googleapis.com",
#     "containerscanning.googleapis.com"
#    ])

#   service = each.key

#   disable_on_destroy = true
# }




