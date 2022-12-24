terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.0"
    }
  }
}

provider "cloudflare" {
  api_token = data.terraform_remote_state.cloudsetup.outputs.api_token_apex_mdekort
}
