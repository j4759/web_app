# web_app
demo deployment for a web app

## Requirements
* Unix OS
* AWS account
* S3 bucket and ECR repo
* Deployment IAM role
* AWS CLI v2


## Configure Environment
* Clone this repo to local machine
* Modify variables.tf defaults and env/ tfvars files to match your deployment environment e.g. region, app name etc.
* In main.tf change backend bucket
* Create the following environment variables:
  ```bash
    export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
    export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
    export AWS_DEFAULT_REGION=<insert desired region>
  ```

## image creation
To build the image and upload to ecr complete the following actions. ECR was chosen as the repository location due to its intergration with ECS.
* Navigate to image directory
* Login to ECR `aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account id>.dkr.ecr.<region>.amazonaws.com`
* `docker build -t app-website-apache .`
* `docker tag app-website-apache:latest <account id>.dkr.ecr.<region>.amazonaws.com/app-website-apache:latest`
* `docker push <account id>.dkr.<region>.amazonaws.com/app-website-apache:latest`

## Deployment 
* Navigate to repository root 
* run `terraform init`
* run `terraform workspace select <dev/prod>`
* run `terraform plan --var-file=env/<stage>.tfvars` and review plan
* run `terraform apply --var-file=env/<stage>.tfvars`


