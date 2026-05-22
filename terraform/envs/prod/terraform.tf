terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.92"
        }
    }

    required_version = ">= 1.2"

    backend "s3" {
        bucket = "infraascode-project-states-bucket"
        key = "prod/terraform.tfstate"
        region = "eu-north-1"
        use_lockfile = true
    }
}