

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

variable "code_build_name" {
type = string
description = "project"
default = "test-demo_code_build12345"
}
variable "deploy_group_name" {
type = string
description = "deployement group"
default = "example-group"
}



variable "deploy_app_name" {
type = string
description = "deploy application name"
default = "java_app"
}