provider "google" {
  project = var.project
  region  = var.region
  }

module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "10.1.1"

  project_id                  = "project-lab1-351507"

  activate_apis = [
    "serviceusage.googleapis.com",
  ]
}


resource "google_cloud_run_service" "default" {
  name     = "cloudrun-srv"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}