data "google_project" "project" {
  project_id = var.project_id
}

data "google_folder" "parent" {
  folder = var.parent_folder_name
}

data "google_projects" "projects_in_folder" {
  filter = "parent.id:${replace(data.google_folder.parent.id, "folders/", "")}"
}

data "google_project" "service_project" {
  count = var.number_of_service_projects
  project_id = element(data.google_projects.projects_in_folder.projects[*].project_id, count.index)
}

resource "google_compute_network" "network" {
  name                            = var.name
  project                         = data.google_project.project.project_id
  auto_create_subnetworks         = var.auto_create_subnets
  description                     = "Shared VPC for projects in the ${var.parent_folder_name} folder"
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = var.delete_default_routes_on_create
}

# Attach host and service projects to the shared VPC
resource "google_compute_shared_vpc_host_project" "host" {
  project = data.google_project.project.project_id
}

resource "google_compute_shared_vpc_service_project" "service" {
  count           = var.number_of_service_projects
  host_project    = google_compute_shared_vpc_host_project.host.project
  service_project = element(tolist(setsubtract(toset(data.google_projects.projects_in_folder.projects[*].project_id), toset([data.google_project.project.project_id]))), count.index)
}

# Create subnetworks and secondary IP ranges for GKE pods & services
resource "google_compute_subnetwork" "subnetwork" {
  count = length(var.gcp_regions)

  name          = "${element(var.gcp_regions, count.index)}-${replace(replace(cidrsubnet(var.cidr_block, local.new_bits, count.index), ".", "-"), "/", "-")}"
  region        = element(var.gcp_regions, count.index)
  project       = data.google_project.project.project_id
  network       = google_compute_network.network.id
  ip_cidr_range = cidrsubnet(var.cidr_block, local.new_bits, count.index)

  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = cidrsubnet(var.gke_pods_cidr_block, local.gke_pods_new_bits, count.index)
  }

  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = cidrsubnet(var.gke_services_cidr_block, local.gke_services_new_bits, count.index)
  }
}

# Assign Subnet User privileges
# Needs to be manually re-run a second time if Subnetwork is re-created
resource "google_project_iam_member" "subnetuser_cloudservices" {
  provider   = google-beta
  count      = var.number_of_service_projects
  project    = data.google_project.project.project_id
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:${element(data.google_project.service_project.*.number, count.index)}@cloudservices.gserviceaccount.com"
}

resource "google_project_iam_member" "subnetuser_gke" {
  provider   = google-beta
  count      = var.number_of_service_projects
  project    = data.google_project.project.project_id
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:service-${element(data.google_project.service_project.*.number, count.index)}@container-engine-robot.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "subnetuser_terraform" {
  count   = var.service_project_service_accounts_count
  project = google_compute_shared_vpc_host_project.host.project
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${element(var.service_project_service_accounts, count.index)}"
}

resource "google_project_iam_member" "security_terraform" {
  count   = var.service_project_service_accounts_count
  project = google_compute_shared_vpc_host_project.host.project
  role    = "roles/compute.securityAdmin"
  member  = "serviceAccount:${element(var.service_project_service_accounts, count.index)}"
}

# Assign Host Service Agent User privileges to the Service Project's Google APIs Service Agent with IAM
resource "google_project_iam_member" "hostagentuser_gke" {
  provider   = google-beta
  count      = var.number_of_service_projects
  project    = data.google_project.project.project_id
  role       = "roles/container.hostServiceAgentUser"
  member     = "serviceAccount:service-${element(data.google_project.service_project.*.number, count.index)}@container-engine-robot.iam.gserviceaccount.com"
}

# Assign Key Encrypter Decrypter privileges to the Service Project's Google APIs Service Agent with IAM
resource "google_project_iam_member" "kms_gke" {
  provider   = google-beta
  count      = var.number_of_service_projects
  project    = data.google_project.project.project_id
  role       = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member     = "serviceAccount:service-${element(data.google_project.service_project.*.number, count.index)}@container-engine-robot.iam.gserviceaccount.com"
}

# Create a NAT router
resource "google_compute_router" "nat" {
  count   = var.create_nat_routers ? length(var.nat_router_regions) : 0
  name    = "nat-router-${element(var.nat_router_regions, count.index)}"
  region  = element(var.nat_router_regions, count.index)
  network = google_compute_network.network.id
  project = data.google_project.project.project_id

}

resource "google_compute_address" "nat" {
  count  = var.create_nat_routers ? length(var.nat_router_regions) * 2 : 0
  name   = "nat-manual-ip-${count.index}"
  region = element(var.nat_router_regions, floor(count.index / 2)) 
  project = data.google_project.project.project_id

}

resource "google_compute_router_nat" "nat_manual" {
  count  = var.create_nat_routers ? length(var.nat_router_regions) : 0
  name   = "nat-${element(var.nat_router_regions, count.index)}"
  router = element(google_compute_router.nat.*.name, count.index)
  region = element(var.nat_router_regions, count.index)
  project = data.google_project.project.project_id

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = [ element(google_compute_address.nat.*.self_link, count.index), element(google_compute_address.nat.*.self_link, count.index + 1) ]

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES"
}

# Create a default route
resource "google_compute_route" "default" {
  name             = "default-route"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.network.name
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
  project          = data.google_project.project.project_id
}
