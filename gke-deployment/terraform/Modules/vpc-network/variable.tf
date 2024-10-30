
variable "vpc-name" {
type = string
description = "name of the vpc"    
}

variable "project-id" {
  type = string
  description = "project id"
}

variable "routing-mode" {
  type = string
  description = "vpc route mode"
}


variable "ip_cidr_range" {
  type =  string
  description = "ip cidr range "
}

variable "region" {
  type = string
  description = "region name"
}

variable "secondary_ip_range_pods_name" {
  type = string
  description = "secondary pod range name"
}

variable "secondary-pods-range" {
  type = string
  description = "secondary pod ip range"
}

variable "secondary_ip_range_services_name" {
  type = string
  description = "sevicce range name"
}

variable "secondary-service-range" {
  type = string
  description = "secondary service ip range"
}

variable "nat_ip_allocate_option" {
  type = string
  description = "nat ip allocation option"
  default = "AUTO_ONLY"
}

variable "source_subnetwork_ip_ranges_to_nat" {
  type = string
  description = "source subnetwork ip ranges to nat"
  default = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "allowed_ports" {
    description = "List of allowed ports"
    type        = list(string)
}

variable "internal_source_ranges" {
    description = "Internal source range allowed"
    type        = list(string)
}

# variable "network_tags" {
#   type = string
#   description = "target tag for gke cluster"
# }

