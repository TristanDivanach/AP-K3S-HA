resource "proxmox_virtual_environment_download_file" "debian13" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.pve_node
  url          = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2"
  file_name    = "debian-13-generic-amd64.iso"
}


locals {
  ssh_pubkey = trimspace(file("~/.ssh/id_ed25519.pub"))

  vms = {
    pve1 = { vm_id = 101, ip = "10.10.20.11/24", cores = 4, memory = 8192 }
    pve2 = { vm_id = 102, ip = "10.10.20.12/24", cores = 4, memory = 8192 }
    pve3 = { vm_id = 103, ip = "10.10.20.13/24", cores = 4, memory = 8192 }
  }
}

module "vm" {
  source   = "../modules/pve-vm"
  for_each = local.vms

  name          = each.key
  vm_id         = each.value.vm_id
  node_name     = var.pve_node
  datastore     = var.vm_storage
  image_file_id = proxmox_virtual_environment_download_file.debian13.id
  ip_cidr       = each.value.ip
  gateway       = "10.10.20.1"
  networks      = [{ bridge = "vmbr1", vlan_id = 20 }]
  ssh_pubkey    = local.ssh_pubkey
  cores         = each.value.cores
  memory        = each.value.memory
  disk_size     = 20
  extra_disks   = [50] # disque dédié au pool ZFS de chaque nœud nested
  tags          = ["ap", "pve-nested"]
}

output "vm_ips" {
  value = { for k, m in module.vm : k => m.ip }
}


