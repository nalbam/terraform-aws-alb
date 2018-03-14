# Load Balancer

resource "aws_lb" "default" {
  internal = false

  availability_zones = [
    "${data.aws_availability_zones.azs.names}"
  ]

  instances = [
    "${var.instances}"
  ]

  vpc_id = "${var.vpc_id}"

  subnets = [
    "${var.subnets}"
  ]

  //  access_logs {
  //    bucket = "foo"
  //    bucket_prefix = "bar"
  //    interval = 60
  //  }

  cross_zone_load_balancing = true
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 300
}
