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

module "vm" {
  source  = "app.terraform.io/Bruttech/vm/google"
  version = "1.0.5"
  # insert required variables here
  depends_on = [module.network]
  app = var.app
  private_subnet_cidr_1 = var.private_subnet_cidr_1
  project = var.project
  region = var.region
  zone = var.zone
  image = var.image
  machine_type = var.machine_type
  }
