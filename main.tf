# setup the GCP provider
provider "google" {
  project = var.project
  region  = var.region
  zone = var.zone
}

provider "google-beta" {
  project     = var.project
  region      = var.region
  zone        = var.zone
}

###############################################
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
################################################

# create a public ip for nat service
resource "google_compute_address" "nat-ip" {
  name = "${var.app_name}-nap-ip"
  project = var.project
  region  = var.region
}
# create a nat to allow private instances connect to internet
resource "google_compute_router" "nat-router" {
  name = "${var.app_name}-nat-router"
  network = google_compute_network.vpc.name
}
resource "google_compute_router_nat" "nat-gateway" {
  name = "${var.app_name}-nat-gateway"
  router = google_compute_router.nat-router.name
  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips = [ google_compute_address.nat-ip.self_link ]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES" 
  depends_on = [ google_compute_address.nat-ip ]
}
output "nat_ip_address" {
  value = google_compute_address.nat-ip.address
}
######################################################

# allow http traffic
resource "google_compute_firewall" "allow-http" {
  name = "${var.app_name}-fw-allow-http"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http"]
}
# allow https traffic
resource "google_compute_firewall" "allow-https" {
  name = "${var.app_name}-fw-allow-https"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags = ["https"]
}
# allow ssh traffic
resource "google_compute_firewall" "allow-ssh" {
  name = "${var.app_name}-fw-allow-ssh"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
}
# allow rdp traffic
resource "google_compute_firewall" "allow-rdp" {
  name = "${var.app_name}-fw-allow-rdp"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  target_tags = ["rdp"]
}
##########################################################
# Create Google Cloud VMs | vm.tf
# Create web server #1
resource "google_compute_instance" "web_private_1" {
  name = "${var.app_name}-vm1"
  machine_type = "e2-micro"
  zone = var.zone
  hostname = "${var.app_name}-vm1.${var.app_domain}"
  tags = ["ssh","http"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  
  metadata_startup_script = "sudo apt-get update;sudo apt-get install -yq build-essential apache2"
  network_interface {
    network = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.private_subnet_1.name
  }
}
# Create web server #2
resource "google_compute_instance" "web_private_2" {
  name = "${var.app_name}-vm2"
  machine_type = "e2-micro"
  zone = var.zone
  hostname = "${var.app_name}-vm2.${var.app_domain}"
  tags = ["ssh","http"]
boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  
  metadata_startup_script = "sudo apt-get update;sudo apt-get install -yq build-essential apache2"
network_interface {
    network = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.private_subnet_1.name
  }
}
##############################################################
# Virtual machine output | vm-output.tf
output "web-1-name" {
  value = google_compute_instance.web_private_1.name
}
output "web-1-internal-ip" {
  value = google_compute_instance.web_private_1.network_interface.0.network_ip
}
output "web-2-name" {
  value = google_compute_instance.web_private_2.name
}
output "web-2-internal-ip" {
  value = google_compute_instance.web_private_2.network_interface.0.network_ip
}
##################################################################
# Load balancer with unmanaged instance group | lb-unmanaged.tf
# used to forward traffic to the correct load balancer for HTTP load balancing
resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  name = "${var.app_name}-global-forwarding-rule"
  project = var.project
  target = google_compute_target_http_proxy.target_http_proxy.self_link
  port_range = "80"
}
# used by one or more global forwarding rule to route incoming HTTP requests to a URL map
resource "google_compute_target_http_proxy" "target_http_proxy" {
  name = "${var.app_name}-proxy"
  project = var.project
  url_map = google_compute_url_map.url_map.self_link
}
# defines a group of virtual machines that will serve traffic for load balancing
resource "google_compute_backend_service" "backend_service" {
  name = "${var.app_name}-backend-service"
  project = "${var.project}"
  port_name = "http"
  protocol = "HTTP"
  health_checks = ["${google_compute_health_check.healthcheck.self_link}"]
  backend {
    group = google_compute_instance_group.web_private_group.self_link
    balancing_mode = "RATE"
    max_rate_per_instance = 100
  }
}
# creates a group of dissimilar virtual machine instances
resource "google_compute_instance_group" "web_private_group" {
  name = "${var.app_name}-vm-group"
  description = "Web servers instance group"
  zone = var.zone
  instances = [
    google_compute_instance.web_private_1.self_link,
    google_compute_instance.web_private_2.self_link
  ]
  named_port {
    name = "http"
    port = "80"
  }
}
# determine whether instances are responsive and able to do work
resource "google_compute_health_check" "healthcheck" {
  name = "${var.app_name}-healthcheck"
  timeout_sec = 1
  check_interval_sec = 1
  http_health_check {
    port = 80
  }
}
# used to route requests to a backend service based on rules that you define for the host and path of an incoming URL
resource "google_compute_url_map" "url_map" {
  name = "${var.app_name}-load-balancer"
  project = var.project
  default_service = google_compute_backend_service.backend_service.self_link
}
# show external ip address of load balancer
output "load-balancer-ip-address" {
  value = google_compute_global_forwarding_rule.global_forwarding_rule.ip_address
}