# Define provider to use Google Cloud
provider "google" {
  project = "mausam-pandey"       # Replace with your GCP project ID
  region  = "us-central1"           # Replace with your desired region
  zone    = "us-central1-c"         # Replace with your desired zone
}


variable "region" {
  description = "The region where GKE cluster will be created"
  default     = "us-central1"
}

variable "cluster_name" {
  description = "my-gke-cluster"
  default     = "my-gke-cluster"
}

variable "node_pool_name" {
  description = "The name of the node pool"
  default     = "default-node-pool"
}

variable "node_count" {
  description = "The initial number of nodes in the node pool"
  default     = 3
}

variable "node_machine_type" {
  description = "Machine type for nodes in the node pool"
  default     = "e2-medium"
}

variable "node_disk_size_gb" {
  description = "Disk size (in GB) for each node"
  default     = 100
}

variable "vpc_network" {
  description = "The VPC network name"
  default     = "default"
}

variable "subnet_name" {
  description = "The subnet name"
  default     = "default"
}

# Create the GKE cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  initial_node_count = 3
  node_version       = "latest"  # You can specify the exact version if you want

  # Define the node pool configuration
  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = var.node_disk_size_gb
    image_type   = "COS"  # Container Optimized OS (default for GKE)
  }

  # Network and Subnet configuration
  network    = var.vpc_network
  subnetwork = var.subnet_name
  }

    autoscaling {
      min_node_count = 1
      max_node_count = 5
    }

    management {
      auto_upgrade = true
      auto_repair  = true
    }
  }
}

# Output the kubeconfig for accessing the GKE cluster
output "kubeconfig" {
  value = google_container_cluster.primary.kube_config[0].raw_kube_config
}
