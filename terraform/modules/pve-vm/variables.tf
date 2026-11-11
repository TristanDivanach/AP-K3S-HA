variable "name"          { type = string }
variable "vm_id"         { type = number }
variable "node_name"     { type = string }
variable "datastore"     { type = string }
variable "image_file_id" { type = string }
variable "ip_cidr"       { type = string }
variable "gateway"       { type = string }
variable "ssh_pubkey"    { type = string }

variable "cores" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 2048
}

variable "disk_size" {
  type    = number
  default = 20
}

variable "extra_disks" {
  description = "Tailles (Go) des disques supplémentaires"
  type        = list(number)
  default     = []
}

variable "networks" {
  description = "Cartes réseau, dans l'ordre (la première reçoit l'IP cloud-init)"
  type = list(object({
    bridge  = string
    vlan_id = optional(number)
  }))
  default = [{ bridge = "vmbr0" }]
}

variable "agent" {
  type    = bool
  default = false
}

variable "tags" {
  type    = list(string)
  default = []
}
