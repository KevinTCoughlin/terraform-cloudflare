resource "cloudflare_zone_settings_override" "security_settings" {
  for_each = local.security_level_zones

  zone_id = each.value.zone_id

  settings {
    security_level = each.value.security_level
  }
}
