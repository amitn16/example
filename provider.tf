terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }

    }
}

provider "google" {

  project = "my-project-lab1-351507"
  region  = "asia-south1"
  zone    = "asia-south1-a"

}
