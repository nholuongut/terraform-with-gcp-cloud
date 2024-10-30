# Storage bucket for Terraform states
resource "google_storage_bucket" "test" {
  name     = var.bucket_name
  location = "US"

  versioning {
    enabled = true
  }
}
