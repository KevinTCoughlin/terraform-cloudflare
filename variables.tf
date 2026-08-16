variable "cloudflare_account_id" {
  description = "Cloudflare account ID that owns the Worker script."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{32}$", var.cloudflare_account_id))
    error_message = "cloudflare_account_id must be a 32-character lowercase hexadecimal Cloudflare account ID."
  }
}

variable "security_contact_email" {
  description = "Email address published in security.txt."
  type        = string

  validation {
    condition     = can(regex("^[^@[:space:]]+@[^@[:space:]]+\\.[^@[:space:]]+$", var.security_contact_email))
    error_message = "security_contact_email must be a valid email address."
  }
}

variable "security_txt_expires" {
  description = "RFC 3339 expiration timestamp published in security.txt. Update it before it expires."
  type        = string

  validation {
    condition     = can(formatdate("YYYY-MM-DD'T'hh:mm:ssZ", var.security_txt_expires))
    error_message = "security_txt_expires must be a valid RFC 3339 timestamp."
  }
}

variable "zones" {
  description = "Cloudflare zones and the controls managed for each zone."
  type = map(object({
    zone_id             = string
    domain              = string
    enable_security_txt = optional(bool, true)
    dmarc_content       = optional(string)
    security_level      = optional(string)
  }))

  validation {
    condition     = length(var.zones) > 0
    error_message = "At least one zone must be configured. An empty map could cause Terraform to destroy managed resources."
  }

  validation {
    condition = alltrue([
      for zone in values(var.zones) :
      can(regex("^[0-9a-f]{32}$", zone.zone_id))
    ])
    error_message = "Every zone_id must be a 32-character lowercase hexadecimal Cloudflare zone ID."
  }

  validation {
    condition = alltrue([
      for zone in values(var.zones) :
      can(regex("^[a-z0-9](?:[a-z0-9-]*[a-z0-9])?(?:\\.[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)+$", zone.domain))
    ])
    error_message = "Every domain must be a lowercase DNS name without a scheme, path, or wildcard."
  }

  validation {
    condition = alltrue([
      for zone in values(var.zones) :
      zone.dmarc_content == null || try(startswith(zone.dmarc_content, "v=DMARC1;"), false)
    ])
    error_message = "dmarc_content must be null or begin with \"v=DMARC1;\"."
  }

  validation {
    condition = alltrue([
      for zone in values(var.zones) :
      zone.security_level == null || try(contains(
        ["off", "essentially_off", "low", "medium", "high", "under_attack"],
        zone.security_level
      ), false)
    ])
    error_message = "security_level must be null or a Cloudflare-supported security level."
  }
}
