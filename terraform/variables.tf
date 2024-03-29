# variable "aws_access_key" {
#     description = "The AWS access key."
# }
#
# variable "aws_secret_key" {
#     description = "The AWS secret key."
# }

variable "app-name" {
  default = "app"
}

variable "dbpass" { default = "testpassword" }

variable "region" {
    description = "The AWS region to create resources in."
    default = "eu-west-1"
}

# TODO: support multiple availability zones, and default to it.
variable "availability_zone" {
    description = "availability zone"
    default = "eu-west-1a"
}

variable "availability_zone2" {
    description = "second availability zone"
    default = "eu-west-1b"
}

variable "ecs_cluster_name" {
    description = "The name of the Amazon ECS cluster."
    default = "main"
}

variable "amis" {
    description = "Which AMI to spawn. Defaults to the AWS ECS optimized images."
    # TODO: support other regions.
    default = {
        us-east-1 = "ami-ba722dc0"
        eu-west-1 = "ami-acb020d5"
        eu-west-2 = "ami-4d809829"
    }
}


variable "autoscale_min" {
    default = "1"
    description = "Minimum autoscale (number of EC2)"
}

variable "autoscale_max" {
    default = "3"
    description = "Maximum autoscale (number of EC2)"
}

variable "autoscale_desired" {
    default = "2"
    description = "Desired autoscale (number of EC2)"
}


variable "instance_type" {
    default = "t2.micro"
}

variable "ssh_pubkey_file" {
    description = "Path to an SSH public key"
    default = "sshkeys/id_rsa.aws.pub"
}
