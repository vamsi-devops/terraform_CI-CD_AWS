 /*
  resource "aws_codebuild_source_credential" "example" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = "204c677009154dad331b6611b8d0747451f4c891"
}
*/
  resource "aws_iam_role" "code_build_role" {
  name = "code_build_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "code_build_policy" {
  role = "${aws_iam_role.code_build_role.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterfacePermission"
      ],
      "Resource":  "*"      
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "*"
      ]
    },
    {
            "Effect": "Allow",
            "Action": [
                "ecr:*",
                "cloudtrail:LookupEvents"
            ],
            "Resource": "*"
        }
  ]
}
POLICY
}

resource "aws_codebuild_project" "demo_code_build" {
  name          = "${var.code_build_name}"
  description   = "test_codebuild_project"
  #build_timeout = "5"
  service_role  =  "${aws_iam_role.code_build_role.name}"

  artifacts {
    type = "NO_ARTIFACTS"
  }


  environment {
    privileged_mode = true  
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

   }

  logs_config {
    cloudwatch_logs {
      group_name  = ""
      stream_name = ""
    }
}

  source {
    type            = "GITHUB"
    location        = "${var.source_location}"
    git_clone_depth = 1
   
    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "master"


  tags = {
    Environment = "Test"
  }
}

/*
resource "aws_codebuild_webhook" "example" {
  project_name = "${aws_codebuild_project.demo_code_build.name}"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "master"
    }
  }
}*/