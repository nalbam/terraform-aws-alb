# terraform-aws-alb

## usage
```
module "demo-dev" {
  source = "git::https://gitlab.com/nalbam/terraform-aws-alb.git"
  region = "${var.region}"

  vpc_id = "vpc-abcde012"
  subnets = [
    "subnet-abcde012", "subnet-bcde012a"
  ]
  security_groups = [
    "sg-edcd9784", "sg-edcd9785"
  ]

  certificate_arn = "${data.aws_acm_certificate.default.arn}"
}
```

## reference
* https://github.com/terraform-aws-modules/terraform-aws-alb
