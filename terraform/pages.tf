resource "cloudflare_pages_project" "site" {
  account_id        = local.cloudflare_account_id
  name              = var.name
  production_branch = var.repo_branch
}

resource "cloudflare_pages_domain" "site" {
  account_id   = local.cloudflare_account_id
  project_name = cloudflare_pages_project.site.name
  domain       = var.domain_name

  depends_on = [
    cloudflare_pages_project.site,
    cloudflare_record.site,
  ]
}
