resource "proxmox_virtual_environment_vm" "this" {
  name      = var.name
  node_name = var.node_name
  vm_id     = var.vm_id
  tags      = var.tags

  agent { enabled = var.agent }

  cpu {
    cores = var.cores
    type  = "host"   # indispensable pour la virtualisation imbriquée
  }

  memory { dedicated = var.memory }

  disk {
    datastore_id = var.datastore
    file_id      = var.image_file_id
    interface    = "virtio0"
    size         = var.disk_size
  }

  dynamic "disk" {
    for_each = var.extra_disks
    content {
      datastore_id = var.datastore
      interface    = "virtio${disk.key + 1}"
      size         = disk.value
      file_format  = "raw"
    }
  }

  dynamic "network_device" {
    for_each = var.networks
    content {
      bridge  = network_device.value.bridge
      vlan_id = network_device.value.vlan_id
    }
  }

  operating_system { type = "l26" }

  initialization {
    datastore_id = var.datastore
    ip_config {
      ipv4 {
        address = var.ip_cidr
        gateway = var.gateway
      }
    }
    user_account {
      username = "admin"
      keys     = [var.ssh_pubkey]
    }
  }
}
