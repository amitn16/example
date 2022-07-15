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
  default = "app1"
}
