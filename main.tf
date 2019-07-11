locals {
    max_private_subnets = min(
        length(var.availability_zones),
        length(var.private_subnet_ranges)
    )

    max_public_subnets = min(
        length(var.availability_zones),
        length(var.public_subnet_ranges)
    )

    vpc_id                      = var.create_vpc ? element(concat(aws_vpc.this.*.id, [""]), 0) : var.imported_vpc_id
}

######
# VPC
######
resource "aws_vpc" "this" {
    count                       = var.create_vpc ? 1 : 0

    cidr_block                  = var.cidr
    enable_dns_hostnames        = true
    enable_dns_support          = true

    tags = merge(
        {
            "Name" = format("%s-%s",
                var.project_name,
                terraform.workspace
            ),
            "Environment" = terraform.workspace,
        },
        var.tags,
        var.vpc_tags
    )
}

###################
# Internet Gateway
###################
resource "aws_internet_gateway" "this" {
    count                       = local.max_public_subnets > 0 ? 1 : 0

    vpc_id                      = local.vpc_id

    tags = merge(
        {
            "Name": format("%s-%s-%s",
                var.project_name,
                terraform.workspace,
                var.public_subnet_suffix
            ),
            "Environment": terraform.workspace
        },
        var.tags,
        var.igw_tags
    )
}

# ##############
# # NAT Gateway
# ##############
# resource "aws_eip" "nat" {
#     count                       = var.create_private_subnets && local.max_private_subnets > 0 ? 1 : 0

#     vpc                         = true
#     tags = merge(
#         {
#             "Name" = format("%s-%s-%s",
#                 var.project_name,
#                 terraform.workspace,
#                 element(var.availability_zones, 0)
#             )
#         },
#         var.tags,
#         # var.nat_eip_tags
#     )
# }

# resource "aws_nat_gateway" "this" {
#     count                       = var.create_private_subnets && local.max_private_subnets > 0 ? 1 : 0

#     allocation_id               = aws_eip.nat[0].id
#     subnet_id                   = aws_subnet.public[0].id

#     tags = merge(
#         {
#             "Name" = format("%s-%s-%s",
#                 var.project_name,
#                 terraform.workspace,
#                 )
#         },
#         var.tags,
#         # var.nat_gateway_tags
#     )

#     depends_on = [ aws_internet_gateway.this ]
# }

# resource "aws_route" "private_nat_gateway" {
#     count                       = var.create_private_subnets && local.max_private_subnets > 0 ? 1 : 0

#     route_table_id              = element(aws_route_table.private.*.id, count.index)
#     destination_cidr_block      = "0.0.0.0/0"
#     nat_gateway_id              = element(aws_nat_gateway.private.*.id, count.index)
# }

################
# Public Routes
################
resource "aws_route_table" "public" {
    count                       = var.create_public_subnets && local.max_public_subnets > 0 ? 1 : 0
    
    vpc_id                      = local.vpc_id

    tags = merge(
        {
            "Name"  = format("%s-%s-%s",
                var.project_name,
                terraform.workspace,
                var.public_subnet_suffix
            )
        },
        var.tags,
        # var.public_route_table_tags
    )
}

resource "aws_route" "public_internet_gateway" {
    count                       = var.create_public_subnets && local.max_public_subnets > 0 ? 1 : 0

    route_table_id              = aws_route_table.public[0].id
    destination_cidr_block      = "0.0.0.0/0"
    gateway_id                  = aws_internet_gateway.this[0].id
}

# #################
# # Private Routes
# #################
# resource "aws_route_table" "private" {
#     count                       = var.create_private_subnets && local.max_private_subnets > 0 ? 1 : 0
    
#     vpc_id                      = local.vpc_id

#     tags = merge(
#         {
#             "Name"  = format("%s-%s-%s",
#                 var.project_name,
#                 terraform.workspace,
#                 var.private_subnet_suffix
#             )
#         },
#         var.tags,
#         # var.private_route_table_tags
#     )
# }
