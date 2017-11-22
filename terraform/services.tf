resource "aws_elb" "test-http" {
    name = "http-elb-${terraform.workspace}"
    security_groups = ["${aws_security_group.load_balancers.id}"]
    subnets = ["${aws_subnet.main.id}"]

    listener {
        lb_protocol = "http"
        lb_port = 80

        instance_protocol = "http"
        instance_port = 3000
    }

    health_check {
        healthy_threshold = 3
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:3000/"
        interval = 5
    }

    cross_zone_load_balancing = true
}

data "template_file" "task-http" {
    template = "${file("task-definitions/test-http.json")}"
    vars = {
      dbname = "${aws_db_instance.default.name}"
      dbpass = "${aws_db_instance.default.password}"
      dbhost = "${aws_db_instance.default.address}"
      dbuser = "${aws_db_instance.default.username}"
      imgtag = "${terraform.workspace == "production" ? "production" : "latest" }"
    }
}

resource "aws_ecs_task_definition" "test-http" {
    family = "app-${terraform.workspace}"
    container_definitions = "${data.template_file.task-http.rendered}"
}

resource "aws_ecs_service" "test-http" {
    name = "app-${terraform.workspace}"
    cluster = "${aws_ecs_cluster.main.id}"
    task_definition = "${aws_ecs_task_definition.test-http.arn}"
    iam_role = "${aws_iam_role.ecs_service_role.arn}"
    desired_count = 1
    depends_on = ["aws_iam_role_policy.ecs_service_role_policy"]

    load_balancer {
        elb_name = "${aws_elb.test-http.id}"
        container_name = "${var.app-name}"
        container_port = 3000
    }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.test-http.name}"
  role_arn           = "arn:aws:iam::373776389706:role/ecsAutoscaleRole"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
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

  depends_on = ["aws_appautoscaling_target.ecs_target"]
}
