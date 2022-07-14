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

# define application name
variable "app_name" {
  type = string
  description = "Application name"
}

# define application domain
variable "app_domain" {
  type = string
  description = "Application domain"
}

# define application environment
variable "app_environment" {
  type = string
  description = "Application environment"
}

/* variable "app_node_count" {
  type = string
  description = "Number of servers to build"
}
*/