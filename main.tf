provider "google" {
  project = var.project
  region  = var.region
  }

resource "google_project_service" "project" {
  project = var.project
  service = "serviceusage.googleapis.com"

  disable_dependent_services = true
}