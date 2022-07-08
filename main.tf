provider "google" {
  project = var.project
  region  = var.region
  service = "serviceusage.googleapis.com"
}

resource "google_cloud_run_service" "nginx-service-1" {
  name     = "nginx-service-my-project-lab1-351507"
  location = "europe-west3"
  template {
    spec {
      containers {
        image = "marketplace.gcr.io/google/nginx1"
        ports {
          container_port = 8080
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "member" {
  location = google_cloud_run_service.nginx-service-1.location
  project  = google_cloud_run_service.nginx-service-1.project
  service  = google_cloud_run_service.nginx-service-1.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}