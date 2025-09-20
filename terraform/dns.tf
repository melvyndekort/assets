resource "cloudflare_dns_record" "apex" {
  zone_id = data.terraform_remote_state.tf_cloudflare.outputs.mdekort_zone_id
  name    = var.domain_name
  type    = "CNAME"
  ttl     = 1
  proxied = false
  content = "${var.name}.pages.dev"
}
