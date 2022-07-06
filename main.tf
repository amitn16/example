provider "google" {
  project = var.project
  region  = var.region
}

resource "google_project" "my_project-in-a-folder" {
  name       = "My Project"
  project_id = "your-project-id"
  folder_id  = google_folder.department1.name
}

resource "google_folder" "department1" {
  display_name = "BU1"
  parent       = "bruttech.com/277860026539"
}

/*
resource "google_compute_firewall" "firewall" {
  name    = "firewall-externalssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] # Not So Secure. Limit the Source Range
  target_tags   = ["externalssh"]
}

resource "google_compute_firewall" "webserverrule" {
  name    = "amit-webserver"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80","443"]
  }

  source_ranges = ["0.0.0.0/0"] # Not So Secure. Limit the Source Range
  target_tags   = ["webserver"]
}

# We create a public IP address for our google compute instance to utilize
resource "google_compute_address" "static" {
  name = "vm-public-address"
  project = var.project
  region = var.region
  depends_on = [ google_compute_firewall.firewall ]
}


resource "google_compute_instance" "dev" {
  name         = var.name
  machine_type = "e2-micro"
  zone         = "${var.region}-a"
  tags         = ["externalssh","webserver"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

 provisioner "remote-exec" {
    connection {
      host        = google_compute_address.static.address
      type        = "ssh"
      user        = var.user
      timeout     = "500s"
      private_key = file(var.privatekeypath)
    }

    inline = [
      "sudo yum -y install epel-release",
      "sudo yum -y install nginx",
      "sudo nginx -v",
    ]
  }

  # Ensure firewall rule is provisioned before server, so that SSH doesn't fail.
  depends_on = [ google_compute_firewall.firewall, google_compute_firewall.webserverrule ]

  service_account {
    email  = var.email
    scopes = ["compute-ro"]
  }

 # metadata = {
 #  ssh-keys = "${var.user}:${file(var.publickeypath)}"
 # }
metadata_startup_script = file("${path.module}/startup.sh")
*/