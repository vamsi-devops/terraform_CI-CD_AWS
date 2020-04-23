
module "code_build_module" {
    source = "./modules/codebuild"
    code_build_name = var.code_build_name
	source_location = var.source_location
}

module "code_deploy_module" {
    source = "./modules/codedeploy"
    deploy_app_name = var.deploy_app_name
	deploy_group_name = var.deploy_group_name
	deploy_config_name = var.deploy_config_name
	ec2_key_name = var.ec2_key_name
	ec2_value_name = var.ec2_value_name
}


module "code_pipeline_module" {
    source = "./modules/codepipeline"
    Oauth_token = var.Oauth_token
	aws_s3_bucket_name = var.aws_s3_bucket_name
	aws_codepipeline_name = var.aws_codepipeline_name
	github_owner_name = var.github_owner_name
	github_repo_name = var.github_repo_name
    code_build_name = var.code_build_name
    deploy_app_name = var.deploy_app_name
    deploy_group_name = var.deploy_group_name

}

module "ecr_create_module" {
    source = "./modules/ECR"
    repo_name = var.repo_name
	

}
