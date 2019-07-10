output "region" {
    description = "Region we created the resource in"
    value = var.region
}

output "vpc_name" {
    value = aws_vpc.name
}