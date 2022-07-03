provider "google" {
  project = var.project
  region  = var.region
}

resource "google_app_engine_application" "app" {
  project = var.project
  location_id = "us-central"
  }