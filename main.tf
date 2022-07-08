provider "google" {
  project = var.project
  region  = var.region
  }

  resource "google_project_service" "project" {
  project = "my-project-lab1-351507"
  service = "serviceusage.googleapis.com"

  disable_dependent_services = true
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