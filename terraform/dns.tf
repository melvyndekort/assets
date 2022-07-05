resource "cloudflare_record" "site" {
  zone_id = data.terraform_remote_state.cloudsetup.outputs.mdekort_zone_id
  name    = var.domain_name
  type    = "CNAME"
  ttl     = 1
  proxied = false
  value   = "${var.name}.netlify.app"
}
