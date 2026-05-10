locals {
  domains = {
    kevintcoughlin = {
      zone_id  = "" # Fill in with actual zone ID from Cloudflare
      name     = "kevintcoughlin.com"
      warnings = ["Security.txt", "DMARC Record Error (2x)"]
    }
    juniperleaves = {
      zone_id  = ""
      name     = "juniperleaves.com"
      warnings = ["Security.txt", "Block AI bots", "AI Labyrinth"]
    }
    cascadiacollections = {
      zone_id  = ""
      name     = "cascadiacollections.com"
      warnings = ["Security.txt", "DMARC Record Error (3x)"]
    }
    warzybrewing = {
      zone_id  = ""
      name     = "warzybrewing.com"
      warnings = ["Security.txt", "Block AI bots", "AI Labyrinth", "Bot Fight Mode"]
    }
    dadscraft = {
      zone_id  = ""
      name     = "dadscraft.com"
      warnings = ["Security.txt"]
    }
    cascadiacollections_workers = {
      zone_id  = ""
      name     = "cascadiacollections.workers.dev"
      warnings = ["Security.txt", "Block AI bots", "AI Labyrinth"]
    }
  }

  # Domain groups for security policy application
  all_zones = { for k, v in local.domains : k => v.zone_id }
}
