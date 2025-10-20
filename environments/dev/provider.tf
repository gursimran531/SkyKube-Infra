terraform {
  cloud {
    organization = "Singhops"

    workspaces {
      project = "SkyKube"
      name    = "development"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.17.0"
    }
  }


  required_version = ">= 1.13"
}
