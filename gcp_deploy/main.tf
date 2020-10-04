terraform {
  required_providers {
    aws = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project     = "terratest12"
  region      = "us-central1-a"
  zone        = "us-central1-a"
  credentials = file(var.gcp_credentials)
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "g1-small"
  metadata = {
    ssh-keys = "ubuntu:${file(var.gcp_public_keys)}"
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.gcp_private_keys)
    host        = self.network_interface[0].access_config[0].nat_ip
  }

  provisioner "remote-exec" {
    inline = ["echo 'Up and running'", ]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${self.network_interface[0].access_config[0].nat_ip}, --private-key=${var.gcp_private_keys} -u ubuntu ./ansible/playbook.yml"
  }
}

resource "google_compute_firewall" "default" {
  name    = "terraform-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8501"]
  }

  allow {
    protocol = "icmp"
  }
}

