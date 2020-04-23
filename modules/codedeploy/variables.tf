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

variable "ec2_value_name" {
type = string
  description = "ec2 value name"
  default = "one"
}