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

#############

# define application name
variable "app_name" {
  type = string
  description = "Application name"
  default = "app1"
}

# define application name
variable "app_domain" {
  type = string
  description = "Application domain"
  default = "bruttech.com"
}

# define application name
variable "machine_type" {
  type = string
  description = "Machine Type"
  default = "e2-micro"
}

# define application name
variable "image" {
  type = string
  description = "Imaage Type"
  default = "ubuntu-os-cloud/ubuntu-1804-lts"
}