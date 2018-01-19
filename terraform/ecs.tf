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

# Cloudwatch Alarms for triggering autoscaling
resource "aws_cloudwatch_metric_alarm" "app_cpu_high" {
  alarm_name           = "app_cpu_high_${terraform.workspace}"
  comparison_operator  = "GreaterThanOrEqualToThreshold"
  evaluation_periods   = "1"
  metric_name          = "CPUUtilization"
  namespace            = "AWS/ECS"
  period               = "60"
  statistic            = "Average"
  threshold            = "70"
  dimensions {
    ClusterName = "${aws_ecs_cluster.main.name}"
    ServiceName = "${aws_ecs_service.test-http.name}"
  }
  alarm_actions = ["${aws_appautoscaling_policy.app_up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_low" {
  alarm_name           = "app_cpu_low_${terraform.workspace}"
  comparison_operator  = "LessThanThreshold"
  evaluation_periods   = "1"
  metric_name          = "CPUUtilization"
  namespace            = "AWS/ECS"
  period               = "60"
  statistic            = "Average"
  threshold            = "20"
  dimensions {
    ClusterName = "${aws_ecs_cluster.main.name}"
    ServiceName = "${aws_ecs_service.test-http.name}"
  }
  alarm_actions = ["${aws_appautoscaling_policy.app_down.arn}"]
}

# Autoscale Target
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.test-http.name}"
  # role_arn           = "arn:aws:iam::373776389706:role/ecsAutoscaleRole"
  role_arn           = "${aws_iam_role.ecs_service_role.arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [
    "aws_ecs_cluster.main",
    "aws_ecs_service.test-http"
  ]
}

# Autoscaling Policies

resource "aws_appautoscaling_policy" "app_up" {
  name                      = "app_scale_up_${terraform.workspace}"
  service_namespace         = "ecs"
  resource_id               = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.test-http.name}"
  scalable_dimension        = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "300"
    metric_aggregation_type = "Maximum"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
  depends_on = ["aws_appautoscaling_target.ecs_target"]
}

resource "aws_appautoscaling_policy" "app_down" {
  name                      = "app_scale_down_${terraform.workspace}"
  service_namespace         = "ecs"
  resource_id               = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.test-http.name}"
  scalable_dimension        = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "300"
    metric_aggregation_type = "Maximum"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }
  depends_on = ["aws_appautoscaling_target.ecs_target"]
}

# resource "aws_appautoscaling_policy" "ecs_policy" {
#   name                    = "scale-down"
#   resource_id             = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.test-http.name}"
#   scalable_dimension      = "ecs:service:DesiredCount"
#   service_namespace       = "ecs"
#
#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 60
#     metric_aggregation_type = "Maximum"
#
#     step_adjustment {
#       metric_interval_upper_bound = 0
#       scaling_adjustment          = -1
#     }
#   }
#
#   depends_on = ["aws_appautoscaling_target.ecs_target"]
# }
