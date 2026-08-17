resource "cloudflare_workers_script" "security_txt" {
  account_id         = var.cloudflare_account_id
  name               = "security-txt-handler"
  module             = true
  compatibility_date = "2024-11-01"
  content            = <<-EOT
export default {
  fetch(request) {
    const url = new URL(request.url);
    if (url.pathname === '/.well-known/security.txt') {
      const body = [
        'Contact: mailto:' + ${jsonencode(var.security_contact_email)},
        'Expires: ' + ${jsonencode(var.security_txt_expires)},
        'Preferred-Languages: en',
        ''
      ].join('\n');

      return new Response(body, {
        status: 200,
        headers: {
          'Content-Type': 'text/plain; charset=utf-8',
          'Cache-Control': 'public, max-age=3600'
        }
      });
    }

    return new Response('Not Found', { status: 404 });
  }
}
EOT
}

resource "cloudflare_workers_route" "security_txt" {
  for_each = local.security_txt_zones

  zone_id     = each.value.zone_id
  pattern     = "${each.value.domain}/.well-known/security.txt*"
  script_name = cloudflare_workers_script.security_txt.name
}

resource "cloudflare_record" "dmarc" {
  for_each = local.dmarc_zones

  zone_id = each.value.zone_id
  name    = "_dmarc"
  type    = "TXT"
  content = each.value.dmarc_content
  ttl     = 3600
}
