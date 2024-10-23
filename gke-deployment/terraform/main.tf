module "vpc-network" {
  source = "./Modules/vpc-network"
  project-id = var.project-id
  vpc-name = var.vpc-name
  region = var.region
  routing-mode = var.routing_mode
  service-range-name = var.service_range_name
  pod-range-name = var.pod_range_name
  secondary-pods-range = var.secondary-pods-range
  seondary-service-range = var.secondary-service-range
  internal_source_ranges = var_internal_source_range
  allowed_ports = var.allowed_ports
  ip_cidr_range = var.ip_cidr_range 
  

}