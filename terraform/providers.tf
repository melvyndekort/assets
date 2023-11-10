terraform {
  required_version = "~> 1.5.0"

  cloud {
    organization = "melvyndekort"

    workspaces {
      name = "assets"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.0"
    }
  }
}

provider "cloudflare" {
  api_token = data.terraform_remote_state.cloudsetup.outputs.api_token_assets
}
