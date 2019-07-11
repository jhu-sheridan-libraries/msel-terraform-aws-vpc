output "region" {
    description = "Region we created the resource in"
    value = var.region
}

output "vpc_name" {
    value = module.vpc.vpc_name
}
