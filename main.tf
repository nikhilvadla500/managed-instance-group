
resource "google_compute_instance_template" "default" {
  name         = "example-template"
  machine_type = "e2-medium"

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network       = "default"  
    access_config {}            
  }
}

resource "google_compute_instance_group_manager" "default" {
  name                = "example-group"
  base_instance_name  = "test-instance"
  target_size         = 3
  zone                = "us-central1-f"
  version {
    instance_template = google_compute_instance_template.default.id
  }
}

resource "google_compute_autoscaler" "default" {
  name    = "example-autoscaler"
  zone    = "us-central1-f"
  target  = google_compute_instance_group_manager.default.id

  autoscaling_policy {
    max_replicas      = 8
    min_replicas      = 2
    cooldown_period   = 90
    cpu_utilization {
      target = 0.60 # 60% average CPU utilization
    }
  }
}
