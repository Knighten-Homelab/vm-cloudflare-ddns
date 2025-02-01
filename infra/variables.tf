########################
#  Secret Related Vars #
########################

variable "vault_token" {
  type        = string
  description = "Vault token to use for authentication"
}

variable "vault_url" {
  type        = string
  description = "Vault URL to use for authentication"
}

variable "vault_skip_tls_verify" {
  type        = bool
  description = "Skip TLS verification for Vault"
  default     = false
}

variable "vault_pve_secrets_path" {
  type        = string
  description = "Path to the secrets in Vault for Proxmox VE"
}

variable "vault_pdns_secrets_path" {
  type        = string
  description = "Path to the secrets in Vault for PowerDNS"
}

variable "vault_ansible_service_account_secrets_path" {
  type        = string
  description = "Path to the secrets in Vault for the Ansible service account"
}

####################
# PVE Related Vars #
####################

variable "pve_url" {
  type        = string
  description = "Proxmox VE API URL"
}

variable "pve_node" {
  type        = string
  description = "Proxmox VE node to use"
}

variable "vm_name" {
  type        = string
  description = "Name of the VM"
}

variable "vm_id" {
  type        = number
  description = "ID of the VM"
}

variable "vm_ip_address" {
  type        = string
  description = "IP address to assign to the VM"
}

variable "vm_cidr_prefix_length" {
  type        = number
  description = "CIDR prefix length for the VM"
}

variable "vm_gateway_address" {
  type        = string
  description = "Gateway address for the VM"
}

variable "vm_dns_servers" {
  type        = string
  description = "DNS servers to use for the VM"
}

variable "vm_vlan" {
  type        = number
  description = "VLAN to use for the VM"
}

variable "vm_ci_store_pool" {
  type        = string
  description = "Storage pool to use for the VM"
}

variable "vm_disk_store_pool" {
  type        = string
  description = "Storage pool to use for the VM disks"
}

#####################
# PDNS Related Vars #
#####################

variable "pdns_url" {
  type        = string
  description = "PowerDNS API URL"
}

variable "dns_record_name" {
  type        = string
  description = "Name of the DNS record to create"
}

variable "dns_zone" {
  type        = string
  description = "DNS zone where the A record will be created"
}
