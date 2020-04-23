provider "github" {
  token        = "${var.Oauth_token}"
  #individual = true
  organization = "${var.github_owner_name}"
}

resource "aws_s3_bucket" "releases" {
  bucket = "${var.aws_s3_bucket_name}"
  acl    = "private"                   
}  

resource "aws_iam_role" "codepipeline_role" {
  name = "test-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = "${aws_iam_role.codepipeline_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.releases.arn}",
        "${aws_s3_bucket.releases.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
	{
    "Action": [
        "codedeploy:CreateDeployment",
        "codedeploy:GetApplicationRevision",
        "codedeploy:GetDeployment",
        "codedeploy:GetDeploymentConfig",
        "codedeploy:RegisterApplicationRevision"
    ],
    "Resource": "*",
    "Effect": "Allow"
	}

  ]
}
EOF
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.aws_codepipeline_name}"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.releases.id}"
    type     = "S3"

 
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner  = "${var.github_owner_name}"
        Repo   = "${var.github_repo_name}"
        OAuthToken = "${var.Oauth_token}"
        Branch = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "${var.code_build_name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["build_output"]
      version         = "1"

configuration = {
  
  DeploymentGroupName= "${var.deploy_group_name}"
  ApplicationName = "${var.deploy_app_name}"
}
    }
  }
}
# A shared secret between GitHub and AWS that allows AWS
# CodePipeline to authenticate the request came from GitHub.
# Would probably be better to pull this from the environment
# or something like SSM Parameter Store.

locals {
  webhook_secret = "pipeline-secret"
}

resource "aws_codepipeline_webhook" "bar" {
  name            = "test-webhook-github-bar" 
  authentication  = "GITHUB_HMAC" 
  target_action   = "Source"
  target_pipeline = "${aws_codepipeline.codepipeline.name}"

  authentication_configuration {
    secret_token = "${local.webhook_secret}"
  }
filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/master"
  }

}

resource "github_repository_webhook" "test" {
  repository = "${var.github_repo_name}"

  #name = "web"

  configuration {
    url          = "${aws_codepipeline_webhook.bar.url}"
    content_type = "form"
    insecure_ssl = true
    secret       = "${local.webhook_secret}"
  }

  events = ["push"]
}