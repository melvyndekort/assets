data "cloudflare_zones" "zone" {
  filter {
    name = "mdekort.nl"
  }
}

resource "cloudflare_record" "site" {
  zone_id = data.cloudflare_zones.zone.zones[0].id
  name    = var.domain_name
  type    = "CNAME"
  ttl     = 1
  proxied = false
  value   = "${var.name}.netlify.app"
}
