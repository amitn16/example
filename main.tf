# setup the GCP provider
provider google {
  project = var.project
  region  = var.region
  zone = var.zone
}

module "network" {
  source  = "app.terraform.io/Bruttech/network/google"
  version = "2.0.3"
  app_name = var.app_name
  private_subnet_cidr_1 = var.private_subnet_cidr_1
  project = var.project
  region = var.region
  zone = var.zone
}

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