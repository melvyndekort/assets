terraform {
  backend "s3" {
    bucket     = "mdekort.tfstate"
    key        = "mdekort-assets.tfstate"
    region     = "eu-west-1"
    encrypt    = "true"
    kms_key_id = "arn:aws:kms:eu-west-1:075673041815:alias/generic"
  }
}

data "terraform_remote_state" "cloudsetup" {
  backend = "s3"

  config = {
    bucket = "mdekort.tfstate"
    key    = "cloudsetup.tfstate"
    region = "eu-west-1"
  }
}

locals {
  cloudflare_account_id = data.terraform_remote_state.cloudsetup.outputs.cloudflare_account_id
}
