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
  depends_on = [module.network]
  name = "${var.app_name}-vm1-bruttech.com"
  machine_type = "e2-micro"
  zone = var.zone
  hostname = "${var.app_name}-vm1"
  tags = ["ssh","http"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  
  metadata_startup_script = "sudo apt-get update;sudo apt-get install -yq build-essential apache2"
  network_interface {
    network = "app1-vpc"
    subnetwork = "app1-private-subnet-1"
  }
}