resource "netlify_site" "site" {
  name          = var.name
  custom_domain = var.domain_name

  repo {
    repo_branch = "main"
    provider    = "github"
    repo_path   = var.repo
  }
}
