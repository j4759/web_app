
data "aws_availability_zones" "region_azs" {
}

# dynamically generate subnet cidr blocks based on number of azs in region
locals {
  public_cidrs = [for zone in data.aws_availability_zones.region_azs.names :
  cidrsubnet(var.cidr_block, 8, (index(data.aws_availability_zones.region_azs.names, zone) + 1))]
  private_cidrs = [for zone in data.aws_availability_zones.region_azs.names :
  cidrsubnet(var.cidr_block, 8, (index(data.aws_availability_zones.region_azs.names, zone) + 1 * 10))]
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.77.0"

  name = "${var.app_name}_${terraform.workspace}"
  cidr = var.cidr_block

  azs             = data.aws_availability_zones.region_azs.zone_ids
  private_subnets = local.private_cidrs
  public_subnets  = local.public_cidrs

  enable_dns_hostnames = true

  enable_nat_gateway = true # allows ecs access to ecr and cloudwatch

  enable_flow_log                      = var.enable_vpcflowlogs
  create_flow_log_cloudwatch_log_group = var.enable_vpcflowlogs
  create_flow_log_cloudwatch_iam_role  = var.enable_vpcflowlogs
  flow_log_max_aggregation_interval    = 60

  vpc_flow_log_tags = {
    Name = "vpc-flow-logs-cloudwatch-logs-default"
  }
}

