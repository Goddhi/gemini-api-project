variable "gke-zone" {
  type = string
  description = "gke region"
}

variable "cluster_name" {
type = string
description = "gke name"
}

variable "vpc-name" {
  type = string
  description = "network name"
}
variable "pod-range-name" {
  type = string
  description = "pod range name"
}

variable "secondary-service-range" {
  type = string
  description = "seondary pod range"
}

variable "secondary-pods-range" {
  type = string
  description = "seondary pod range"
}
variable "secondary_ip_range_services_name" {
  type = string
  description = "secondary ip range service name"
  
}
variable "subnet-name" {
  type = string
  description = "subnet name"
}

variable "master_ipv4_cidr_block" {
  type = string
  description = "master node ipv4 cidr range"
}

variable "channel-name" {
  type = string
  description  = "k8s release channel"
}
variable "authorized-network-ip" {
  type = string
  description = "authorize network ip"
}

variable "namespace" {
  type = string
  description = "namespace name"
}

variable "machine_type" {
  type = string
  description = "machine type"
}

variable "disk_size_gb" {
  type = string
  description = "disk size"
}

variable "environment" {
  type = string
  description = "environment of gke"
}

variable "network_tags" {
  type = string
  description = "network tags for firewall rule"
}