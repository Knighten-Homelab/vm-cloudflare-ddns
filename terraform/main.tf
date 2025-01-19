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

module "cloudflare-ddns-vm" {
  source = "github.com/Johnny-Knighten/terraform-homelab-pve-vm?ref=1.7.1"

  pve_node = var.pve_node
  pve_name = var.vm_name
  pve_id   = var.vm_id

  pve_is_clone   = true
  pve_full_clone = true
  pve_template   = "debian-12-cloud-init-template"

  pve_boot_on_start   = true
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

  pdns_zone        = var.dns_zone
  pdns_record_name = var.dns_record_name

  awx_organization     = var.awx_org
  awx_inventory        = var.awx_inventory
  awx_host_groups      = ["proxmox-hosts", "ipa-managed-clients"]
  awx_host_name        = var.awx_host_name
  awx_host_description = var.awx_host_description
}

data "awx_organization" "target-org" {
  name = var.awx_org
}

resource "awx_project" "cloudflare-ddns-project" {
  name                 = "Homelab - Cloudflare DDNS"
  scm_type             = "git"
  scm_url              = "git@github.com:Johnny-Knighten/homelab-cloudflare-ddns.git"
  scm_branch           = var.awx_project_git_branch
  scm_update_on_launch = false
  scm_credential_id    = var.awx_github_scm_cred_id
  organization_id      = data.awx_organization.target-org.id
}

data "awx_inventory" "target-inv" {
  name            = var.awx_inventory
  organization_id = data.awx_organization.target-org.id
}

resource "awx_job_template" "cf-ddns-deploy-template" {
  name           = "Deploy - Cloudflare DDNS (Containerized)"
  job_type       = "run"
  inventory_id   = data.awx_inventory.target-inv.id
  project_id     = awx_project.cloudflare-ddns-project.id
  playbook       = "ansible/deploy-docker-compose-cloudflare-ddns.yml"
  become_enabled = true
  extra_vars     = <<YAML
---
host: ${var.awx_host_name}
vault_ipaadmin_password: '{{ ipaadmin_principal }}'
vault_ipaclient_password: '{{ ipaadmin_password }}'
cloudflare_ddns_records: 
${yamlencode(var.awx_cloudflare_ddns_records)}
YAML
}

resource "awx_job_template_credential" "required-deploy-creds" {
  for_each        = var.awx_deploy_job_required_creds
  job_template_id = awx_job_template.cf-ddns-deploy-template.id
  credential_id   = each.value
}
