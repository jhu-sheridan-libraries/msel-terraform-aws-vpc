variable "project_name" {
    type = string
    description = "This string will be used to generate tags and resource names"    
}

variable "create_vpc" {
    type = bool
    description = "If true, will create a new VPC. If False, it will use imported_vpc_id"
    default = true
}

variable "cidr" {
    type = string
    description = "The CIDR for the VPC. Default is 10.0.0.0/16"
    default = "10.0.0.0/16"
}

variable "imported_vpc_id" {
    type = string
    description = "If create_vpc is false, this will be used to create a datasource"
    default = ""
}

variable "availability_zones" {
    type = list(string)
    description = "Availability zones for subnet placement. The number of AZs control the number of subnets that are created."
    default = ["us-east-1a", "us-east-1c", "us-east-1e"]
}

variable "tags" {
    type = map(string)
    description = "Tags to be added to all resources"
    default = {}
}

variable "vpc_tags" {
    type = map(string)
    description = "Tags to be added to VPC resources"
    default = {}
}

# Internet Gateway
variable "igw_tags" {
    type = map(string)
    description = "Additional tags for the internet gateway"
    default = {}
}

# Public Subnets
variable "create_public_subnets" {
    type = bool
    description = "If true, this will create public subnets across availability zones."
    default = true
}

variable "public_subnet_ranges" {
    type = list(string)
    description = "The CIDR ranges used for public subnets. Must be equal to or great than the number of AZs"
    default = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
}

variable "public_subnet_suffix" {
    type = "string"
    description = "Suffix to append to public subnets name"
    default = "public"
}
#Private Subnets
variable "create_private_subnets" {
    type = bool
    description = "If true, this will create private subnets across availability zones."
    default = true
}

variable "private_subnet_ranges" {
    type = list(string)
    description = "The CIDR ranges used for private subnets. Must be equal to or great than the number of AZs"
    default = [ "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24" ]
}

variable "private_subnet_suffix" {
    type = "string"
    description = "Suffix to append to private subnets name"
    default = "private"
}