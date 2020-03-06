variable "gcp_admin_emails" {
  type = list(string)
}
variable "gcp_billing_id" {
  type = string
}
variable "gcp_org_id" {
  type = string
}
variable "gcp_project_id" {
  type = string
}
variable "gcs_bucket" {
  type = string
}
variable "location" {
  default = "US"
  type    = string
}

locals {
  gcp_admin_ids = [
    for email in var.gcp_admin_emails :
    "user:${email}"
  ]
}

terraform {
  required_version = ">= 0.12"
}

provider "google-beta" { version = "~> 3.8" }

// Fetch the billing account, which is required to create the GCS bucket.
data "google_billing_account" "account" {
  provider = google-beta

  billing_account = var.gcp_billing_id
  open            = true
}

// Create the project + IAM
resource "google_project" "bigquery-utils" {
  provider = google-beta

  billing_account = data.google_billing_account.account.id
  name       = "BigQuery Utils"
  org_id     = var.gcp_org_id
  project_id = var.gcp_project_id

  # Project creation is eventually consistent
  provisioner "local-exec" {
    command = "sleep 10"
  }
}
data "google_iam_policy" "bigquery-utils-project" {
  provider = google-beta

  binding {
    role = "roles/owner"
    members = local.gcp_admin_ids
  }
}
resource "google_project_iam_policy" "bigquery-utils" {
  provider = google-beta

  policy_data = data.google_iam_policy.bigquery-utils-project.policy_data
  project     = google_project.bigquery-utils.project_id
}

// Configure the storage bucket + IAM
resource "google_storage_bucket" "bigquery-utils" {
  provider = google-beta

  location           = var.location
  name               = var.gcs_bucket
  project            = google_project.bigquery-utils.project_id
  force_destroy      = true
  requester_pays     = true
  bucket_policy_only = true
}
data "google_iam_policy" "bigquery-utils-bucket" {
  provider = google-beta

  binding {
    role = "roles/storage.admin"
    members = local.gcp_admin_ids
  }
  binding {
    role = "roles/storage.objectViewer"
    members = [
      "allUsers",
    ]
  }
}
resource "google_storage_bucket_iam_policy" "bigquery-utils" {
  provider = google-beta

  bucket      = google_storage_bucket.bigquery-utils.name
  policy_data = data.google_iam_policy.bigquery-utils-bucket.policy_data
}

// Enable BQ API and create our BQ datasets
resource "google_project_service" "project" {
  provider = google-beta

  disable_dependent_services = true
  disable_on_destroy         = true
  project                    = google_project.bigquery-utils.project_id
  service                    = "bigquery.googleapis.com"

  # Enabling the service is eventually consistent
  provisioner "local-exec" {
    command = "sleep 120"
  }
}
resource "google_bigquery_dataset" "farmhash" {
  provider = google-beta

  access {
    role          = "READER"
    special_group = "allAuthenticatedUsers"
  }
  access {
    role          = "OWNER"
    special_group = "projectOwners"
  }
  dataset_id                 = "farmhash"
  delete_contents_on_destroy = true
  location                   = var.location
  project                    = google_project.bigquery-utils.project_id
}
