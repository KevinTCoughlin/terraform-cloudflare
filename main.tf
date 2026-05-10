output "configured_zones" {
  description = "Cloudflare zones configured"
  value = {
    for k, v in local.domains : k => {
      zone_id = v.zone_id
      domain  = v.name
    }
  }
}

output "security_txt_worker" {
  description = "Security.txt worker deployment"
  value = {
    script_name = cloudflare_workers_script.security_txt.name
    script_id   = cloudflare_workers_script.security_txt.id
    routes      = [for k, v in cloudflare_workers_route.security_txt : v.pattern]
  }
}
