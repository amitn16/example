provider "google" {
  project = var.project
  region  = var.region
  }

module "project-factory_example_project_services" {
  source  = "terraform-google-modules/project-factory/google//examples/project_services"
  version = "13.0.0"
  # insert the 1 required variable here
  project_id = var.project_id
  enable = serviceusage.googleapis.com
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
}

