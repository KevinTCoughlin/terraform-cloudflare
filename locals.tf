locals {
  security_txt_zones = {
    for name, zone in var.zones : name => zone
    if zone.enable_security_txt
  }

  dmarc_zones = {
    for name, zone in var.zones : name => zone
    if zone.dmarc_content != null
  }

  security_level_zones = {
    for name, zone in var.zones : name => zone
    if zone.security_level != null
  }
}
