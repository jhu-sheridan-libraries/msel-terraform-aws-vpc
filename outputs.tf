output "vpc_id" {
    value = local.vpc_id
}

output "vpc_arn" {
    value = concat(aws_vpc.this.*.arn, [""])[0]
}

output "igw_id" {
    value = concat(aws_internet_gateway.this[0].id, [""])[0]
}

output "public_route_table_id" {
    value = concat(aws_route_table.public[0].id, [""])[0]
}
