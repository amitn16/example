provider "google" {
  project = var.project
  region  = var.region
  
  }

resource "google_secret_manager_secret" "secret-basic" {
  secret_id = "app1"

  labels = {
    label = "my-label1"
  }

  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
      replicas {
        location = "us-east1"
      }
    }
  }
}
