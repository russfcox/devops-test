resource "aws_ecs_cluster" "main" {
    name = "ECS${terraform.workspace}"
}

resource "aws_autoscaling_group" "ecs-cluster" {
    # availability_zones = ["${var.availability_zone}", "${var.availability_zone2}"]
    name = "ECS app ${terraform.workspace}"
    min_size = "${var.autoscale_min}"
    max_size = "${var.autoscale_max}"
    desired_capacity = "${var.autoscale_desired}"
    health_check_type = "EC2"
    launch_configuration = "${aws_launch_configuration.ecs.name}"
    vpc_zone_identifier = ["${aws_subnet.main.id}"]
}

resource "aws_launch_configuration" "ecs" {
    name = "ECS app ${terraform.workspace}"
    image_id = "${lookup(var.amis, var.region)}"
    instance_type = "${var.instance_type}"
    security_groups = ["${aws_security_group.ecs.id}"]
    iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"
    key_name = "${aws_key_pair.key.key_name}"
    associate_public_ip_address = true
    user_data = "#!/bin/bash\necho ECS_CLUSTER='ECS${terraform.workspace}' > /etc/ecs/ecs.config"
}

# ECS cluster Autoscaling and monitoring

# Cloudwatch Alarms for triggering autoscaling
resource "aws_cloudwatch_metric_alarm" "ecs_mem_high" {
  alarm_name           = "cluster_mem_high_${terraform.workspace}"
  comparison_operator  = "GreaterThanOrEqualToThreshold"
  evaluation_periods   = "1"
  metric_name          = "MemoryReservation"
  namespace            = "AWS/ECS"
  period               = "60"
  statistic            = "Average"
  threshold            = "80"
  dimensions {
    ClusterName = "${aws_ecs_cluster.main.name}"
  }
  alarm_actions = ["${aws_appautoscaling_policy.ecs_up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "ecs_mem_low" {
  alarm_name           = "app_mem_low_${terraform.workspace}"
  comparison_operator  = "LessThanThreshold"
  evaluation_periods   = "1"
  metric_name          = "MemoryReservation"
  namespace            = "AWS/ECS"
  period               = "60"
  statistic            = "Average"
  threshold            = "40"
  dimensions {
    ClusterName = "${aws_ecs_cluster.main.name}"
  }
  alarm_actions = ["${aws_appautoscaling_policy.ecs_down.arn}"]
}

# # AppAutoscale Target for ecs service
# resource "aws_appautoscaling_target" "ecs_target" {
#   max_capacity       = 4
#   min_capacity       = 2
#   resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.test-http.name}"
#   # role_arn           = "arn:aws:iam::373776389706:role/ecsAutoscaleRole"
#   role_arn           = "${aws_iam_role.ecs_service_role.arn}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
#
#   depends_on = [
#     "aws_ecs_cluster.main",
#   ]
# }

# Autoscaling Policies

resource "aws_autoscaling_policy" "ecs_up" {
  name                      = "ecs_scale_up_${terraform.workspace}"
  autoscaling_group_name    = "${aws_autoscaling_group.ecs-cluster.name}"
  scalable_dimension        = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "300"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
  depends_on = ["aws_autoscaling_group.ecs-cluster"]
}

resource "aws_autoscaling_policy" "ecs_down" {
  name                      = "ecs_scale_down_${terraform.workspace}"
  autoscaling_group_name    = "${aws_autoscaling_group.ecs-cluster.name}"
  scalable_dimension        = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "300"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }
  depends_on = ["aws_autoscaling_group.ecs-cluster"]
}
