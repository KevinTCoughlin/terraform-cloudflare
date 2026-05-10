terraform {
  required_version = ">= 1.0"
  
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  cloud {
    organization = "YOUR_ORG"

    workspaces {
      name = "cloudflare-domains"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
