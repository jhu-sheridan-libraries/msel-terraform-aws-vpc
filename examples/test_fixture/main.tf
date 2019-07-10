provider "aws" {
    region = var.region
}

data "aws_availability_zones" "available" {
}

module "vpc" {
    source = "../../"
    project_name = "test-example"
    tags = {
        Owner  = "derek"
    }
}