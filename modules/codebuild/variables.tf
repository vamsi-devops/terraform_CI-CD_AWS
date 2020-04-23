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