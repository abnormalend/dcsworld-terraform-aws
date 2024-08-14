terraform {

  cloud {
    organization = "abnormalend-terraform"
    workspaces {
      name = "dcsworld"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
    http = {
    source = "hashicorp/http"
   }
  }
}