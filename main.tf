provider "google" {
  project = var.project
  region  = var.region
  }

module "project-factory_example_project_services" {
  source  = "terraform-google-modules/project-factory/google//examples/project_services"
  version = "13.0.0"
  # insert the 1 required variable here
  project_id                  = var.project_id
  enable_apis                 = var.enable
  disable_services_on_destroy = true

  activate_apis = [
    "sqladmin.googleapis.com",
    "bigquery-json.googleapis.com",
    "serviceusage.googleapis.com",
  ]
  activate_api_identities = [{
    api = "serviceusage.googleapis.com"
    roles = [
      "roles/serviceusage.serviceUsageAdmin",
    ]
  }]
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

