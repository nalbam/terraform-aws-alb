# Application Load Balancer

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.region
}

resource "aws_alb" "default" {
  name = var.name

  subnets = var.subnets

  security_groups = var.security_groups

  internal = var.internal

  tags = merge(
    var.tags,
    {
      "Name" = var.name
    },
  )
  //  access_logs {
  //    bucket = "${var.log_bucket_name}"
  //    prefix = "${var.log_location_prefix}"
  //    enabled = "${var.enable_logging}"
  //  }

  //  depends_on = [
  //    "default.log_bucket"
  //  ]
}

//resource "aws_s3_bucket" "default" {
//  bucket = "${var.log_bucket_name}"
//  policy = "${var.bucket_policy == "" ? data.aws_iam_policy_document.bucket_policy.json : var.bucket_policy}"
//  force_destroy = "${var.force_destroy_log_bucket}"
//  count = "${var.create_log_bucket ? 1 : 0}"
//  tags = "${merge(var.tags, map("Name", var.log_bucket_name))}"
//}

resource "aws_alb_target_group" "default" {
  name = "${var.name}-tg"

  port                 = var.backend_port
  protocol             = upper(var.backend_protocol)
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay

  health_check {
    interval            = var.health_check_interval
    path                = var.health_check_path
    port                = var.health_check_port
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    protocol            = var.backend_protocol
    matcher             = var.health_check_matcher
  }

  target_type = var.target_type

  stickiness {
    type            = "lb_cookie"
    cookie_duration = var.cookie_duration
    enabled         = var.cookie_duration == 1 ? false : true
  }

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name}-tg"
    },
  )

  depends_on = [aws_alb.default]
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.default.arn
  port              = var.http_port
  protocol          = "HTTP"
  count             = contains(var.protocols, "HTTP") ? 1 : 0

  default_action {
    target_group_arn = aws_alb_target_group.default.id
    type             = "forward"
  }

  depends_on = [aws_alb.default]
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.default.arn
  port              = var.https_port
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  ssl_policy        = var.security_policy
  count             = contains(var.protocols, "HTTPS") ? 1 : 0

  default_action {
    target_group_arn = aws_alb_target_group.default.id
    type             = "forward"
  }

  depends_on = [aws_alb.default]
}
