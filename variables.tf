# define GCP project name
variable "project" {
  type = string
  description = "GCP project name"
  default = "lithe-bonito-356116"
}

# define GCP region
variable "region" {
  type = string
  description = "GCP region"
  default     = "us-central1"
}
# define GCP zone
variable "zone" {
  type = string
  description = "GCP zone"
  default     = "us-central1-a"
}

# define private subnet
variable "private_subnet_cidr_1" {
  type = string
  description = "private_subnet_CIDR 1"
  default     = "10.1.11.0/24"
}

# define application name
variable "app_name" {
  type = string
  description = "Application name"
  default = "app3"
}

# define host name
variable "app" {
  type = string
  description = "host name"
  default = "apphost"
}

# define application name
variable "image" {
  type = string
  description = "image name"
  default = "centos-cloud/centos-7"
}

# define application name
variable "machine_type" {
  type = string
  description = "machine name"
  default = "e2-micro"
}