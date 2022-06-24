terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.0"
    }
    netlify = {
      source  = "Fantom-App/netlify"
      version = ">= 0.7.10"
    }
  }
}

provider "cloudflare" {
  api_token = data.terraform_remote_state.cloudsetup.outputs.api_token_apex_mdekort
}

provider "netlify" {
  token = local.secrets.netlify.token
}
