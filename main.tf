provider "google" {
  project = var.project
  region  = var.region
  }

resource "google_cloud_run_service" "nginx-service" {
  name = "${var.environment}-nginx-service"
  location = "europe-west3"
  template {
    spec {
      containers {
        image = "marketplace.gcr.io/google/nginx1"
        ports {
          container_port = 80
        }
      }
    }
  }
  traffic {
    percent = 100
    latest_revision = true
  }
}