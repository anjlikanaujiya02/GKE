module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 28.0"

  project_id = var.project_id
  name       = "gke-mumbai-cluster"
  region     = var.region

  zones = [
    "asia-south1-a",
    "asia-south1-b",
    "asia-south1-c"
  ]

  network    = var.network
  subnetwork = var.subnetwork

  ip_range_pods     = "mumbai-gke-pods-range"
  ip_range_services = "mumbai-gke-services-range"

  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  dns_cache                  = false

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "e2-medium"
      node_locations     = "asia-south1-b,asia-south1-c"
      min_count          = 1
      max_count          = 10
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      auto_repair        = true
      auto_upgrade       = true
      initial_node_count = 1

      service_account = "project-service-account@${var.project_id}.iam.gserviceaccount.com"
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    default-node-pool = {
      env = "dev"
    }
  }

  node_pools_metadata = {
    default-node-pool = {
      node-pool = "mumbai"
    }
  }

  node_pools_taints = {
    default-node-pool = [
      {
        key    = "gpu-node"
        value  = "true"
        effect = "PREFER_NO_SCHEDULE"
      }
    ]
  }

  node_pools_tags = {
    default-node-pool = ["mumbai-gke"]
  }
}
