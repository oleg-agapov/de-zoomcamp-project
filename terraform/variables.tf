variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
  default     = "de-zoomcamp-2023-project-v2"
}

variable "gcp_region" {
  description = "Region for GCP resources. Choose as per your location: https://cloud.google.com/about/locations"
  type        = string
  default     = "europe-west6"
}

variable "gcp_credentials_path" {
  description = "Path to GCP credentials file"
  type        = string
  default     = "/Users/oleg/de-zoomcamp-project-v2/.google/terraform-service-account.json"
}
