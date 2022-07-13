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
  default     = "us-central"
}
# define GCP zone
variable "zone" {
  type = string
  description = "GCP zone"
  default     = "us-central1"
}

# define private subnet
variable "private_subnet_cidr_1" {
  type = string
  description = "private_subnet_CIDR 1"
  default     = "10.10.1.0/24"
}