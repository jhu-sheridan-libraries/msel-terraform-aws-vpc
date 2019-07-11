provider "aws" {
    region = "us-east-1"
}

data "aws_availability_zones" "available" {
}

module "vpc" {
    create_vpc = true
    cidr = "10.0.0.0/16"
    source = "../../"
    project_name = "test-example"
    tags = {
        Environment = "${terraform.workspace}"
        Owner = "The module author"
    }
}