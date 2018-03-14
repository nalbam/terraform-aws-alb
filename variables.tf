data "aws_availability_zones" "azs" {}

variable region {
  default = "us-east-1"
}

variable "instances" {
  type = "list"
  //default = []
  description = "A list of instance ids to place in the ELB pool."
}

variable vpc_id {
  //default = ""
}

variable "subnets" {
  type = "list"
  //default = []
  description = "List of subnets to place Elastic Load Balancer"
}

variable "certificate_id" {
  //default = ""
  description = "The ARN of an SSL certificate you have uploaded to AWS IAM."
}
