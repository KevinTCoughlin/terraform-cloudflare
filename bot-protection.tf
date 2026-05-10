# Bot Protection & AI Security Configuration
# Fixes: Bot Fight Mode, Block AI bots, AI Labyrinth warnings

# Enable Bot Fight Mode on warzybrewing.com
resource "cloudflare_zone_settings_override" "bot_protection" {
  for_each = {
    warzybrewing = local.domains.warzybrewing.zone_id
    # Add more zones if Bot Fight Mode needs to be enabled elsewhere
  }

  zone_id = each.value

  settings {
    bot_fight_mode {
      fight_mode = true
    }
    security_level = "high"
  }
}

# AI Crawler Block - Firewall rules to block AI bots
# Applies to: juniperleaves.com, warzybrewing.com, cascadiacollections.workers.dev
resource "cloudflare_firewall_rule" "block_ai_bots" {
  for_each = {
    juniperleaves = local.domains.juniperleaves.zone_id
    warzybrewing  = local.domains.warzybrewing.zone_id
  }

  zone_id = each.value
  name    = "Block AI Crawlers"
  action  = "block"
  filter_id = cloudflare_firewall_rules_filter.ai_bots[each.key].id
}

resource "cloudflare_firewall_rules_filter" "ai_bots" {
  for_each = {
    juniperleaves = local.domains.juniperleaves.zone_id
    warzybrewing  = local.domains.warzybrewing.zone_id
  }

  zone_id = each.value
  description = "Block common AI crawler user agents"
  expression = "(cf.bot_management.score < 30) or (http.user_agent contains \"GPTBot\") or (http.user_agent contains \"CCBot\") or (http.user_agent contains \"anthropic\") or (http.user_agent contains \"Claude\")"
}

# AI Labyrinth - Enable intelligence via rate limiting and behavioral analysis
# This is a zone setting that uses Cloudflare's AI to detect crawlers
resource "cloudflare_zone_settings_override" "ai_labyrinth" {
  for_each = {
    juniperleaves                  = local.domains.juniperleaves.zone_id
    warzybrewing                   = local.domains.warzybrewing.zone_id
    cascadiacollections_workers    = local.domains.cascadiacollections_workers.zone_id
  }

  zone_id = each.value

  settings {
    security_level = "high"
    # AI Labyrinth works with bot management; enable detection
    bot_management {
      fight_mode = true
    }
  }
}
