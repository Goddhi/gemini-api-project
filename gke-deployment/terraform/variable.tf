variable "project-id" {
  description = "project id name"
  type = string
}

variable "region" {
  description = "gke region"
  type = string
}

variable "zone" {
  description = "gke zone"
  type = string
}
variable "gke-zone" {
  description = "gke zone"
  type = string
}
variable "vpc-name" {
  description = "vpc name"
  type = string
}

variable "routing_mode" {
  description = "routing mode"
  type = string
}

variable "secondary_ip_range_services_name" {
  description = "service range name"
  type = string
}

variable "secondary_ip_range_pods_name" {
  description = "pods range name"
  type = string
}

variable "secondary-pods-range" {
  description = "secondary pods range "
  type = string
}

variable "secondary-service-range" {
  description = "secondary service range"
  type = string
}



variable "internal_source_ranges" {
  description = " firewall rule internal source range"  
  type = list(string)
}

variable "allowed_ports" {
    description = "List of allowed ports"
    type        = list(string)
}

variable "source_subnetwork_ip_ranges_to_nat" {
  type = string
  description = "source subnetwork ip ranges to nat"
  default = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "nat_ip_allocate_option" {
  type = string
  description = "nat ip allocation option"
  default = "AUTO_ONLY"
}

variable "ip_cidr_range" {
  type = string
  description = "subnet ip range"

}

variable "cluster_name" {
type = string
description = "gke name"
}

variable "namespace" {
  type = string
  description = "gke namespace"
}

variable "channel-name" {
  type = string
  description  = "k8s release channel"
}

variable "master_ipv4_cidr_block" {
  type = string
  description = "control plane ipv4 cidr block"
}

variable "authorized-network-ip" {
  type = string
  description = "authorize network ip"
}

variable "machine_type" {
  type = string
  description = "machine type for node"
}

variable "disk_size_gb" {
  type = string
  description = "disk size"
}

variable "environment" {
  type = string
  description = "environment of gke"
}

# variable "network_tags" {
#   type = string
#   description = "firewall tag for gke"
# }