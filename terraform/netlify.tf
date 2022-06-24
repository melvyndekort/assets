resource "netlify_site" "assets" {
  name = "mdekort-assets"

  repo {
    repo_branch = "main"
    dir         = "src"
    provider    = "github"
    repo_path   = "melvyndekort/assets"
  }
}
