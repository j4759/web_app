# deployment variables 

variable "app_name" {
  type    = string
  default = "app"
  description = "The name of the app you will deploy"
}

variable "deployment_role_arn" {
  type = string
  description = "The arn of the iam role used to deploy the app to AWS e.g arn:aws:iam::012345678910:role/role-name"
}

variable "region" {
  type    = string
  default = "eu-west-1"
  description = "AWS region to deploy the app to e.g. eu-west-1, us-east-2"
}


variable "deployment_account_id" {
  type = string
  description = "The id of the AWS account you will deploy the app to e.g. 012345678910"
}

# networking and security

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
  description = "Range of private IPs to assign to VPC"
}

variable "elb_allowlist" {
  type = list
  description = "Cidr blocks to allow on app load balancer security group, for public access put 0.0.0.0/0"
  default = [<add ips here>]
}


# ecs vars

variable "task_cpu" {
  type = number
  description = "amount of CPU allocated to each ecs task e.g. 256"
}

variable "task_memory" {
  type = number
  description = "amount of memory allocated to each ecs task e.g. 512"
}

variable "task_desired_count" {
  type = number
  description = "Number of tasks for ecs to deploy"
}

variable "task_container_port" {
  type = number
  default = 80
  description = "The networking port you wish opened on your tasks e.g. 80, 443 etc."
}

variable "task_container_protocal" {
  type = string
  default = "tcp"
  description = "The networking protocol to enable on your tasks"
}
