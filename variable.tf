variable "machine_type" {
    default = "e2-micro"
}

variable "name" {
    type = string
}

variable "zone" {
    default = "asia-south1-a"
}

variable "image" {
    default = "rhel-cloud/rhel-7"
}
