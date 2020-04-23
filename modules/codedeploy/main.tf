resource "aws_iam_role" "code_deploy_role" {
  name = "code_deploy_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole_attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = "${aws_iam_role.code_deploy_role.name}"
}





resource "aws_codedeploy_app" "java_app" {
compute_platform = "Server"
name = "${var.deploy_app_name}"
}




resource "aws_codedeploy_deployment_group" "java_app" {
app_name = "${aws_codedeploy_app.java_app.name}"
deployment_group_name = "${var.deploy_group_name}"
deployment_config_name = "${aws_codedeploy_deployment_config.foo.id}"
service_role_arn = "${aws_iam_role.code_deploy_role.arn}"

ec2_tag_set {
ec2_tag_filter {
key = "${var.ec2_key_name}"
type = "KEY_AND_VALUE"
value = "${var.ec2_value_name}"
}
}



auto_rollback_configuration {
enabled = false
events = ["DEPLOYMENT_FAILURE"]
}


}


resource "aws_codedeploy_deployment_config" "foo" {
  deployment_config_name = "${var.deploy_config_name}"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 0
  }
}

