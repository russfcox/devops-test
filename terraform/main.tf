provider "aws" {
    # access_key = "${var.aws_access_key}"
    # secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
    shared_credentials_file = "~/.aws/credentials"
}

resource "aws_key_pair" "key" {
    key_name = "ssh-key-${terraform.workspace}"
    public_key = "${file(var.ssh_pubkey_file)}"
}

resource "aws_iam_role" "ecs_host_role" {
    name = "ecs_host_role_${terraform.workspace}"
    assume_role_policy = "${file("policies/ecs-role.json")}"
}

# resource "aws_iam_role" "ecs_autoscaling_role" {
#   name = "ecs_autoscaling_role_${terraform.workspace}"
#   assume_role_policy = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
# }
