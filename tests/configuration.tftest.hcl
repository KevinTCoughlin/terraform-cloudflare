mock_provider "cloudflare" {}

run "plans_expected_resources" {
  command = plan

  variables {
    cloudflare_account_id  = "00000000000000000000000000000000"
    security_contact_email = "security@example.com"
    security_txt_expires   = "2027-12-31T23:59:59Z"

    zones = {
      example = {
        zone_id             = "11111111111111111111111111111111"
        domain              = "example.com"
        enable_security_txt = true
        dmarc_content       = "v=DMARC1; p=none; rua=mailto:dmarc@example.com"
        security_level      = "high"
      }
    }
  }

  assert {
    condition     = cloudflare_workers_script.security_txt.module
    error_message = "The ES module Worker must be uploaded in module mode."
  }

  assert {
    condition     = cloudflare_workers_route.security_txt["example"].pattern == "example.com/.well-known/security.txt*"
    error_message = "The Worker route must use the zone domain and security.txt path."
  }

  assert {
    condition     = cloudflare_record.dmarc["example"].content == "v=DMARC1; p=none; rua=mailto:dmarc@example.com"
    error_message = "The configured DMARC policy must be preserved exactly."
  }

  assert {
    condition     = cloudflare_zone_settings_override.security_settings["example"].settings[0].security_level == "high"
    error_message = "The configured security level must be applied to the selected zone."
  }
}
