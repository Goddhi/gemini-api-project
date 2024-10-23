variable "zone" {
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

variable "namespace-name" {
  type = string
  description = "namespace name"
}

