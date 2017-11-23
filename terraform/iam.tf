resource "aws_iam_role_policy" "ecs_instance_role_policy" {
    name = "ecs_instance_role_policy_${terraform.workspace}"
    policy = "${file("policies/ecs-instance-role-policy.json")}"
    role = "${aws_iam_role.ecs_host_role.id}"
}

resource "aws_iam_role" "ecs_service_role" {
    name = "ecs_service_role_${terraform.workspace}"
    assume_role_policy = "${file("policies/ecs-role.json")}"
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
    name = "ecs_service_role_policy_${terraform.workspace}"
    policy = "${file("policies/ecs-service-role-policy.json")}"
    role = "${aws_iam_role.ecs_service_role.id}"
}

resource "aws_iam_instance_profile" "ecs" {
    name = "ecs-instance-profile_${terraform.workspace}"
    path = "/"
    role = "${aws_iam_role.ecs_host_role.name}"
}
