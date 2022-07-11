provider "google" {
  project = var.project
  region  = var.region
  
  }

resource "google_binary_authorization_attestor" "attestor" {
  name = "test-attestor"
  attestation_authority_note {
    note_reference = google_container_analysis_note.note.name
    public_keys {
      id = data.google_kms_crypto_key_version.version.id
      pkix_public_key {
        public_key_pem      = data.google_kms_crypto_key_version.version.public_key[0].pem
        signature_algorithm = data.google_kms_crypto_key_version.version.public_key[0].algorithm
      }
    }
  }
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/viewer"
    members = [
      "user:amit@bruttech.com",
    ]
  }
}

resource "google_binary_authorization_attestor_iam_policy" "policy" {
  project = google_binary_authorization_attestor.attestor.project
  attestor = google_binary_authorization_attestor.attestor.name
  policy_data = data.google_iam_policy.admin.policy_data
}