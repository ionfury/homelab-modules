output "control_plane_url" {
  description = "Full HTTPS URL for the Kubernetes Control Plane"
  value       = "https://${var.cluster_endpoint}:6443"
}

