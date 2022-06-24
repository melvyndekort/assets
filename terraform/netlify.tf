resource "netlify_site" "assets" {
  name = "assets"

  repo {
    repo_branch = "main"
    dir         = "src"
    provider    = "github"
    repo_path   = "melvyndekort/assets"
  }
}
