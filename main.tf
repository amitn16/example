provider "google" {
  project = var.project
  region  = var.region
}
resource "google_storage_bucket" "my-project-lab1-351507" {
  name     = "test-bucket-my-project-lab1-351507"
  location = "US"
}

resource "google_storage_bucket_object" "archive" {
  name   = "index.zip"
  bucket = google_storage_bucket.my-project-lab1-351507.name
  source = "./code/index.zip"
}

resource "google_cloudfunctions_function" "function" {
  name        = "function-test"
  description = "My function"
  runtime     = "nodejs16"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.my-project-lab1-351507.name
  source_archive_object = google_storage_bucket_object.archive.name
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