# web_app

## Overview
demo deployment for a web app

This repo deploys a simple apache2 website as a docker container hosted on AWS Fargate

Fargate handles autoscaling. However, the maximum and minimum number of tasks fargate can deploy can be changed if the range is insufficient. In addition the compute and memory allocations of each task can be changed to vertically scale the service. These settings can be configured in the tfvars files for each deployment stage.

The infrastructure is deployed by a github terraform workflow and the web app's state is stored in S3

To make changes to the service you require contributor status on the repo and an AWS iam user to update the image, please contact the repo admin if you would like these permissions.

## Architecture Diagram

![Architecture Diagram](ArchitectureDiagram.png)


## Environment Requirements
* Unix OS
* Docker
* Git authenticated to Github
* AWS IAM user in deployment account
* AWS CLI v2


## Terraform Requirements

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | ~> 5.0 |
| <a name="module_s3_log_bucket"></a> [s3\_log\_bucket](#module\_s3\_log\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 1.22.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 2.77.0 |

### Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.api_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_log_group.app_cloudtrail_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.app_ecs_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_metric_alarm.alb_5xx_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_ecs_cluster.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.cloudtrail_cloudwatch_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloudtrail_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.task_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.ecs_tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_sns_topic.alerting](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.alerting_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [random_integer.log_bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [aws_availability_zones.region_azs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alerting_email"></a> [alerting\_email](#input\_alerting\_email) | An email to recieve monitoring alerts - managed by github | `string` | n/a | yes |
| <a name="input_allowlist_cidr"></a> [allowlist\_cidr](#input\_allowlist\_cidr) | Allowlist a single IP using X.X.X.X/32, or a larger range of IPs e.g. X.X.X.X/16, or for public access put 0.0.0.0/0 - managed by github | `string` | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | The name of the app you will deploy | `string` | `"app"` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | Range of private IPs to assign to VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_deployment_account_id"></a> [deployment\_account\_id](#input\_deployment\_account\_id) | The id of the AWS account you will deploy the app to e.g. 012345678910 | `string` | n/a | yes |
| <a name="input_deployment_role_arn"></a> [deployment\_role\_arn](#input\_deployment\_role\_arn) | The arn of the iam role used to deploy the app to AWS e.g arn:aws:iam::012345678910:role/role-name - managed by github | `string` | n/a | yes |
| <a name="input_enable_cloudtrail"></a> [enable\_cloudtrail](#input\_enable\_cloudtrail) | Setup up a cloudtrail to deliver api logs to logging bucket - true or false | `bool` | n/a | yes |
| <a name="input_enable_vpcflowlogs"></a> [enable\_vpcflowlogs](#input\_enable\_vpcflowlogs) | Enables VPC flow logs for app VPC, if flow logs are required for specific subnets or ENIs additional resources will be required | `bool` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region to deploy the app to e.g. eu-west-1, us-east-2 | `string` | `"eu-west-1"` | no |
| <a name="input_state_bucket"></a> [state\_bucket](#input\_state\_bucket) | s3 bucket where state is stored - managed by github | `string` | n/a | yes |
| <a name="input_task_container_port"></a> [task\_container\_port](#input\_task\_container\_port) | The networking port you wish opened on your tasks e.g. 80, 443 etc. | `number` | `80` | no |
| <a name="input_task_container_protocal"></a> [task\_container\_protocal](#input\_task\_container\_protocal) | The networking protocol to enable on your tasks | `string` | `"tcp"` | no |
| <a name="input_task_cpu"></a> [task\_cpu](#input\_task\_cpu) | amount of CPU allocated to each ecs task e.g. 256 | `number` | n/a | yes |
| <a name="input_task_desired_count"></a> [task\_desired\_count](#input\_task\_desired\_count) | Number of tasks for ecs to deploy | `number` | n/a | yes |
| <a name="input_task_memory"></a> [task\_memory](#input\_task\_memory) | amount of memory allocated to each ecs task e.g. 512 | `number` | n/a | yes |

### Outputs

No outputs.

---

## Development Process
* Clone this repo to local machine
* Make desired changes to code (if you make changes to the docker image see image creation)
* Push changes to repo
* Create a PR, the github workflow will deploy to dev
* Review changes in deployment account, request a review from a repo admin
* If the PR is approved your changes will be pushed to prod
  

---

## image creation
To make build the image and upload to ecr complete the following actions.
* Create the following environment variables:
  ```bash
    export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
    export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
    export AWS_DEFAULT_REGION=<insert desired region>
  ```
* Navigate to image directory
* Login to ECR `aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account id>.dkr.ecr.<region>.amazonaws.com`
* `docker build -t <app_name>-repo-<env> .`
* `docker tag <app_name>-repo-<env> <account id>.dkr.ecr.<region>.amazonaws.com/<app_name>-repo-<env>:latest`
* `docker push <account id>.dkr.ecr.<region>.amazonaws.com/<app_name>-repo-<env>:latest` 

---


