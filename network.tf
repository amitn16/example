# create VPC
resource "google_compute_network" "vpc" {
  name = "${var.app_name}-vpc"
  auto_create_subnetworks = "false" 
  routing_mode = "GLOBAL"
}

# create private subnet
resource "google_compute_subnetwork" "private_subnet_1" {
  provider = "google"
  purpose = "PRIVATE"
  name = "${var.app_name}-private-subnet-1"
  ip_cidr_range = var.private_subnet_cidr_1
  network = google_compute_network.vpc.name
  region = var.region
}