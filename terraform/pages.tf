locals {
  cloudflare_account_id = data.terraform_remote_state.tf_cloudflare.outputs.cloudflare_account_id
}

resource "cloudflare_pages_project" "site" {
  account_id        = local.cloudflare_account_id
  name              = var.name
  production_branch = var.repo_branch

  lifecycle {
    ignore_changes = [
      build_config,
      deployment_configs,
    ]
  }
}

resource "cloudflare_pages_domain" "apex" {
  account_id   = local.cloudflare_account_id
  project_name = cloudflare_pages_project.site.name
  name         = cloudflare_dns_record.apex.name

  depends_on = [
    cloudflare_pages_project.site,
    cloudflare_dns_record.apex,
  ]
}
