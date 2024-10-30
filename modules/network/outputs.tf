output "service_project_service_accounts" {
  value = var.service_project_service_accounts
}

output "parent_folder_name" {
  value = var.parent_folder_name
}

output "nat_ip_addresses" {
  value = google_compute_address.nat.*.address
}