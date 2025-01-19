vault_url="https://vault.knighten.io"
vault_skip_tls_verify=false
vault_pve_secrets_path="kv/homelab-pve-terraform-agent"
vault_pdns_secrets_path="kv/pdns"
vault_awx_secrets_path="kv/awx-knighten-io"
vault_ansible_service_account_secrets_path="kv/homelab-ansible-sa"

pve_url="https://primary.pve.knighten.io:8006/api2/json"
pve_node="primary"
vm_name="cloudflare-ddns"
vm_id=201
vm_ip_address="192.168.25.13"
vm_cidr_prefix_length=24
vm_gateway_address="192.168.25.1"
vm_dns_servers="192.168.25.100 192.168.25.101 192.168.25.1"
vm_vlan=6
vm_ci_store_pool="local-zfs"
vm_disk_store_pool="local-zfs"

pdns_url="http://dns.knighten.io:8080/"
dns_record_name="cloudflare-ddns"
dns_zone="knighten.io"

awx_url="https://awx.knighten.io/"
awx_host_name="cloudflare-ddns"
awx_host_description="Cloudflare DDNS VM"
awx_project_git_branch="main"
awx_github_scm_cred_id=4
awx_deploy_job_required_creds={
    ansible_sa_ssh = 3
    freeipa_secrets = 6
    cloudflare_api_key = 7
}
awx_cloudflare_ddns_records = [
  {
    zone      = "knighten.io"
    subdomain = "game"
    proxied   = false
  },
  {
    zone      = "knighten.io"
    subdomain = "ha"
    proxied   = true
  },
  {
    zone      = "knighten.io"
    subdomain = "overseerr"
    proxied   = true
  }
]
