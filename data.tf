data "google_organization" "org" {
  domain = var.org_domain
}

#data "google_billing_account" "acct" {
#  billing_account = var.billing_account_id
#  open            = true
#}

data "google_client_config" "client" {}

data "google_client_openid_userinfo" "client" {}
