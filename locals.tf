locals {
  domains = {
    kevintcoughlin = {
      zone_id  = "a69ae848e05a8bce4101376544ef2218"
      name     = "kevintcoughlin.com"
      warnings = ["Security.txt", "DMARC Record Error (2x)"]
    }
    juniperleaves = {
      zone_id  = "4e4501a6ae503617e55d719701d02766"
      name     = "juniperleaves.com"
      warnings = ["Security.txt", "Block AI bots", "AI Labyrinth"]
    }
    cascadiacollections = {
      zone_id  = "e3fe82d3546c569ec6135fb5bb159fda"
      name     = "cascadiacollections.com"
      warnings = ["Security.txt", "DMARC Record Error (3x)"]
    }
    warzybrewing = {
      zone_id  = "121d6c7564dac317a16db38b1e16860d"
      name     = "warzybrewing.com"
      warnings = ["Security.txt", "Block AI bots", "AI Labyrinth", "Bot Fight Mode"]
    }
    dadscraft = {
      zone_id  = "d0e466cc8f9c0dd484c9877d71aca5ee"
      name     = "dadscraft.com"
      warnings = ["Security.txt"]
    }
    cascadiacollections_workers = {
      zone_id  = "e3fe82d3546c569ec6135fb5bb159fda" # Same account, nested zone
      name     = "cascadiacollections.workers.dev"
      warnings = ["Security.txt", "Block AI bots", "AI Labyrinth"]
    }
  }

  # Domain groups for security policy application
  all_zones = { for k, v in local.domains : k => v.zone_id }
}
