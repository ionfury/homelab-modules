
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.1"
    }
  }
}

variable "kubeconfig_host" {
  type = string
}

variable "kubeconfig_client_certificate" {
  type = string
}

variable "kubeconfig_client_key" {
  type = string
}

variable "kubeconfig_cluster_ca_certificate" {
  type = string
}

provider "kubernetes" {
  host                   = var.kubeconfig_host
  client_certificate     = var.kubeconfig_client_certificate
  client_key             = var.kubeconfig_client_key
  cluster_ca_certificate = var.kubeconfig_cluster_ca_certificate
}

data "kubernetes_nodes" "this" {}

data "kubernetes_server_version" "this" {}


