variable "pve_endpoint" {
  type = string
}

variable "pve_api_token" {
  type      = string
  sensitive = true
}

variable "pve_node" {
  description = "Nom du nœud Proxmox physique"
  type        = string
}

variable "vm_storage" {
  description = "Datastore des disques de VM (ex. local-zfs)"
  type        = string
}

variable "ssh_pubkey" {
  type = string
}
