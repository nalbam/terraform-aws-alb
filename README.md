# terraform-aws-lb

## usage
```
module "demo-dev" {
  source = "git::https://gitlab.com/nalbam/terraform-aws-lb.git"
  region = "${var.region}"

  instances = [
    "i-sample"
  ]

  certificate_id = "${data.aws_acm_certificate.default.arn}"
}
```
