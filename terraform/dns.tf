resource "cloudflare_record" "assets" {
  zone_id = data.terraform_remote_state.cloudsetup.outputs.mdekort_zone_id
  name    = "assets"
  type    = "CNAME"
  ttl     = 1
  proxied = false
  value   = "mdekort-assets.netlify.app"
}
