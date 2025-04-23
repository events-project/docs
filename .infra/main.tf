terraform {
  backend "s3" {
    bucket         = "coinify-tf-state"
    key            = "tf-infra/services/docs-terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "coinify"
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "coinify-tf-state"
    key    = "tf-infra/global-terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "sandbox" {
  backend = "s3"
  config = {
    bucket = "coinify-tf-state"
    key    = "tf-infra/sandbox/terraform.tfstate"
    region = "us-east-1"
  }
}
