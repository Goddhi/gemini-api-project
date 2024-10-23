variable "project-id" {
  description = "project id name"
  type = string
}

variable "region" {
  description = "gke region"
  type = "string"
}

variable "zone" {
  description = "gke zone"
  type = "string"
}
variable "vpc-name" {
  description = "vpc name"
  type = string
}

variable "routing_mode" {
  description = "routing mode"
  type = string
}

variable "service_range_name" {
  description = "service range name"
  type = string
}

variable "pod_range_name" {
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

