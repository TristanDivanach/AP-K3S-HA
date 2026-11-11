terraform {
  required_version = ">= 1.6"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.120.0" # mets la dernière version affichée sur registry.terraform.io
    }
  }
}

provider "proxmox" {
  endpoint  = var.pve_endpoint
  api_token = var.pve_api_token
  insecure  = true # certificat autosigné du PVE ; à noter dans le backlog

  ssh {
    username    = "root"
    private_key = file("~/.ssh/id_ed25519")


    node {
      name = var.pve_node
      address = "192.168.2.9"
   }
  }
}
