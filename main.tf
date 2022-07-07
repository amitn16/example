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
  source = "function.zip"
}
resource "google_cloudfunctions_function" "function" {
  name        = "function-test"
  description = "My function"
  runtime     = "nodejs16"
  source_archive_bucket = google_storage_bucket.bucketamit2203.name
  source_archive_object = google_storage_bucket_object.archive.name
  available_memory_mb   = 128
  trigger_http          = true
  entry_point           = "helloGET"
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}