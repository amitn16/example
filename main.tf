provider "google" {
  project = var.project
  region  = var.region
}

resource "google_project" "project" {
  name       = "My Project"
  project = "my-project-lab1-351507"
  }

resource "google_app_engine_application" "app" {
  project     = google_project.project.project
  location_id = "us-central"
}