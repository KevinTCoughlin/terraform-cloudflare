resource "cloudflare_zone" "zones" {
  for_each = {
    for k, v in local.domains : k => v.name
  }

  account_id = var.cloudflare_account_id
  zone       = each.value
  plan       = "free" # Adjust based on your actual plan
}

output "zones" {
  description = "Cloudflare zone IDs"
  value = {
    for k, v in cloudflare_zone.zones : k => {
      zone_id = v.id
      domain  = v.zone
    }
  }
}

output "security_txt_worker" {
  description = "Security.txt worker deployment"
  value = {
    script_name = cloudflare_worker_script.security_txt.name
    script_id   = cloudflare_worker_script.security_txt.id
    routes      = [for k, v in cloudflare_workers_route.security_txt : v.pattern]
  }
}
