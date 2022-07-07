provider "google" {
  project = var.project
  region  = var.region
}

resource "google_storage_bucket" "bucketamit2203" {
  name     = "bucketamit2203"
  location = "US"
}

resource "google_storage_bucket_object" "archive" {
  name   = "function.zip"
  bucket = google_storage_bucket.bucketamit2203.name
  source = "./code/function.zip"
}