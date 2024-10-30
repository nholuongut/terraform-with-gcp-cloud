output "google_org_id" {
  value = data.google_organization.org.org_id
}

output "client_openid_userinfo" {
  value = data.google_client_openid_userinfo.client.email
}

output "terraform_service_accounts" {
  value = { for account in module.google_project : account.service_account => account }
}

output "nat_ip_addresses" {
  value = [for addresses in module.google_network : addresses.nat_ip_addresses]
}
