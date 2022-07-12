variable "region" {
    type = string
    default = "us-central1"
}

variable "project" {
    type = string
    default = "lithe-bonito-356116"
}

variable "environment" {
    type = string
    default = "dev"
}

variable "project_id" {
  description = "The GCP project you want to enable APIs on"
    type = string
    default = "lithe-bonito-356116"
}

variable "enable" {
  description = "Actually enable the APIs listed"
  type = string
  default = "serviceusage.googleapis.com"
}