terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.4.0"
    }
  }
}

provider "google" {
  credentials = var.gcp_credentials
  project     = var.gcp_project
  region      = var.gcp_region
}

# Creating Pub-Sub Topic
resource "google_pubsub_topic" "mapped-data-topic" {
  name    = "mapped-data"
  project = var.gcp_project

  labels = {

  }

  message_retention_duration = "864000s"
  message_storage_policy {
    allowed_persistence_regions = [
      var.gcp_region
    ]
  }

}

# Creating PubSub Subscription
resource "google_pubsub_subscription" "mapped-data-sub" {
  name       = "mapped-data-subscription"
  topic      = google_pubsub_topic.mapped-data-topic.name
  depends_on = [google_pubsub_topic.mapped-data-topic]

  ack_deadline_seconds = 600
}

variable "gcp_project" {
  type    = string
  default = "terraform-404307"
}

variable "gcp_region" {
  type    = string
  default = "us-central1"
}

variable "gcp_credentials" {
  type      = string
  sensitive = true
}
