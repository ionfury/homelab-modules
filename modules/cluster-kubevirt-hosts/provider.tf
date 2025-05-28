/*
provider "kubernetes" {
  host                   = yamldecode(var.kubernetes_config).clusters[0].cluster.server
  client_certificate     = base64decode(yamldecode(var.kubernetes_config).users[0].user.client-certificate-data)
  client_key             = base64decode(yamldecode(var.kubernetes_config).users[0].user.client-key-data)
  cluster_ca_certificate = base64decode(yamldecode(var.kubernetes_config).clusters[0].cluster.certificate-authority-data)
}
*/
provider "kubernetes" {} #in-cluster auth https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#in-cluster-config
