
resource "google_compute_instance" "firstvm" {
  machine_type = var.machine_type
  name = var.name
  zone = var.zone
  boot_disk {
    initialize_params {
      image = "rhel-cloud/rhel-7"
    }
  }
  network_interface {
    network = "default"
  }
}



output "instance_id" {
  value = google_compute_instance.firstvm.instance_id
}


