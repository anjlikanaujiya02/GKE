output "cluster_name" {
  value = module.gke.name
}

output "cluster_endpoint" {
  value     = module.gke.endpoint
  sensitive = true
}

output "cluster_ca" {
  value     = module.gke.ca_certificate
  sensitive = true
}
