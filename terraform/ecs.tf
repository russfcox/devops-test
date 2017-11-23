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
