# Bot Protection & AI Security Configuration
# Fixes: Bot Fight Mode, Block AI bots, AI Labyrinth warnings

# Enable Bot Fight Mode and high security level on applicable zones
resource "cloudflare_zone_settings_override" "security_settings" {
  for_each = {
    juniperleaves               = local.domains.juniperleaves.zone_id
    warzybrewing                = local.domains.warzybrewing.zone_id
    cascadiacollections_workers = local.domains.cascadiacollections_workers.zone_id
  }

  zone_id = each.value

  settings {
    security_level = "high"
  }
}
