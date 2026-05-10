# Security.txt Configuration
# Serves /.well-known/security.txt on all domains to fix "Security.txt not configured" warnings

resource "cloudflare_workers_route" "security_txt" {
  for_each = local.all_zones

  zone_id     = each.value
  pattern     = "*/${each.key}.well-known/security.txt"
  script_name = cloudflare_worker_script.security_txt.name

  depends_on = [cloudflare_worker_script.security_txt]
}

resource "cloudflare_worker_script" "security_txt" {
  account_id = var.cloudflare_account_id
  name       = "security-txt-handler"
  content    = <<-EOT
export default {
  fetch(request) {
    const url = new URL(request.url);
    if (url.pathname === '/.well-known/security.txt') {
      return new Response(
        `Contact: security@example.com
Expires: 2027-12-31T23:59:59Z
Preferred-Languages: en`,
        {
          status: 200,
          headers: {
            'Content-Type': 'text/plain; charset=utf-8',
            'Cache-Control': 'max-age=3600'
          }
        }
      );
    }
    return new Response('Not Found', { status: 404 });
  }
}
EOT
}

# DMARC Configuration
# Validates and configures DMARC records to fix "DMARC Record Error" warnings
# Applies to: kevintcoughlin.com, cascadiacollections.com, warzybrewing.com

resource "cloudflare_record" "dmarc" {
  for_each = {
    kevintcoughlin      = local.domains.kevintcoughlin.zone_id
    cascadiacollections = local.domains.cascadiacollections.zone_id
    warzybrewing        = local.domains.warzybrewing.zone_id
  }

  zone_id = each.value
  name    = "_dmarc"
  type    = "TXT"
  value   = "v=DMARC1; p=quarantine; rua=mailto:dmarc@${each.key}.com"
  ttl     = 3600
}
