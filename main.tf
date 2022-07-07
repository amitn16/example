provider "google" {
  project = var.project
  region  = var.region
}

resource "google_storage_bucket" "bucketamit2203" {
  name     = "bucketamit2203"
  location = "US"
}
