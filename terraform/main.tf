terraform {
  backend "local" {}
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

resource "google_storage_bucket" "data_lake" {
  name     = "${var.gcp_project_id}-datalake"
  location = var.gcp_region

  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled = false
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30 # days
    }
  }

  force_destroy = true
}

resource "google_bigquery_dataset" "raw_data" {
  dataset_id = "raw_data"
  project    = var.gcp_project_id
  location   = var.gcp_region
}

resource "google_bigquery_dataset" "dev" {
  dataset_id = "dev"
  project    = var.gcp_project_id
  location   = var.gcp_region
}

resource "google_bigquery_dataset" "prod" {
  dataset_id = "prod"
  project    = var.gcp_project_id
  location   = var.gcp_region
}
