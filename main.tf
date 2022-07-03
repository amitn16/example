provider "google" {
  project = var.project
  region  = var.region
}

resource "google_project" "my_project" {
  name       = "My Project"
  project_id = "my-project-lab1-351507"
  org_id     = "1234567"
}

resource "google_app_engine_application" "app" {
  project     = google_project.my_project.project_id
  location_id = "us-central"
}