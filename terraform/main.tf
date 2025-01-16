provider "vault" {
  address         = var.vault_url
  skip_tls_verify = var.vault_skip_tls_verify
  token           = var.vault_token
}

data "vault_generic_secret" "pve_secrets" {
  path = var.vault_pve_secrets_path
}

provider "proxmox" {
  pm_api_url  = var.pve_url
  pm_user     = data.vault_generic_secret.pve_secrets.data["username"]
  pm_password = data.vault_generic_secret.pve_secrets.data["password"]
}

data "vault_generic_secret" "pdns_secrets" {
  path = var.vault_pdns_secrets_path
}

provider "powerdns" {
  server_url = var.pdns_url
  api_key    = data.vault_generic_secret.pdns_secrets.data["terraform_api_key"]
}

data "vault_generic_secret" "awx_secrets" {
  path = var.vault_awx_secrets_path
}

provider "awx" {
  hostname = var.awx_url
  username = data.vault_generic_secret.awx_secrets.data["terraform-user"]
  password = data.vault_generic_secret.awx_secrets.data["terraform-password"]
}

data "vault_generic_secret" "ansible_sa_secrets" {
  path = var.vault_ansible_service_account_secrets_path
}

module "overseerr-vm" {
  source = "github.com/Johnny-Knighten/terraform-homelab-pve-vm?ref=1.7.1"

  pve_node = var.pve_node
  pve_name = var.vm_name
  pve_id   = var.vm_id

  pve_is_clone   = true
  pve_full_clone = true
  pve_template   = "debian-12-cloud-init-template"

  pve_boot_on_start = true
  pve_startup_options = "order=0,up=30"

  pve_use_ci             = true
  pve_ci_ssh_user        = "ansible"
  pve_ci_ssh_private_key = data.vault_generic_secret.ansible_sa_secrets.data["ssh-key-private"]
  pve_ci_ssh_keys = [
    data.vault_generic_secret.ansible_sa_secrets.data["ssh-key-public"]
  ]
  pve_ci_user               = "ansible"
  pve_ci_use_dhcp           = false
  pve_ci_ip_address         = var.vm_ip_address
  pve_ci_cidr_prefix_length = var.vm_cidr_prefix_length
  pve_ci_gateway_address    = var.vm_gateway_address
  pve_ci_dns_servers        = var.vm_dns_servers
  pve_ci_storage_location   = var.vm_ci_store_pool

  #  Required For Debian 12 Cloud Init
  pve_add_serial = true

  pve_networks = [
    {
      model  = "virtio"
      bridge = "vmbr0"
      tag    = var.vm_vlan
      queues = 0
    }
  ]

  pve_core_count = 2

  pve_memory_size    = 4096
  pve_memory_balloon = 0

  pve_disk_size             = "15G"
  pve_disk_storage_location = var.vm_disk_store_pool

  pdns_zone        = "homelab.lan"
  pdns_record_name = var.dns_record_name

  awx_organization     = "Homelab"
  awx_inventory        = "Homelab Endpoints"
  awx_host_groups      = ["proxmox-hosts", "docker-hosts", "ipa_managed_clients"]
  awx_host_name        = var.awx_host_name
  awx_host_description = var.awx_host_description
}
