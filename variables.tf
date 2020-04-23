variable "code_build_name" {
    type = string
  description = "name of the code build"
  default = "test-demo_code_build12345"
}

variable "source_location" {
    type = string
  description = "The source location."
  default = "https://github.com/vamsi-devops-org/aws_pipeline_demo.git"
}

variable "deploy_app_name" {
type = string
  description = "name of the deploy_app_name "
  default = "java_app"
}

variable "deploy_group_name" {
type = string
  description = "name of the deploy_group_name"
  default = "example-group"
}
variable "deploy_config_name" {
type = string
  description = "name of the deploy_group_name"
  default = "java_deployment_config"
}

variable "ec2_key_name" {
type = string
  description = "The tag key name"
  default = "agent"
}



variable "Oauth_token" {
type = string
description = "authentication token"
default = "14b5a3f2cfc3af60b1bc770d35f97f208e2d1173"
}

variable "aws_s3_bucket_name" {
type = string
description = "s3 bucket"
default = "pipeline123-releases"
}


variable "aws_codepipeline_name" {
type = string
description = "aws codepipeline name"
default = "tf-test-pipeline1345"
}


variable "github_owner_name" {
type = string
description = "github owner"
default = "vamsi-devops-org"
}

variable "github_repo_name" {
type = string
description = "github repo"
default = "aws_pipeline_demo"
}




variable "ec2_value_name" {
type = string
  description = "ec2 value name"
  default = "one"
}


variable "repo_name" {
  type = string
  default = "ecr_demo_repo"
}