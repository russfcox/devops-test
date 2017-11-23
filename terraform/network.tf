resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags {
      Name = "${terraform.workspace}"
    }
}

resource "aws_route_table" "external" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main.id}"
    }
    tags {
      Name = "${terraform.workspace}"
    }
}

resource "aws_route_table_association" "external-main" {
    subnet_id = "${aws_subnet.main.id}"
    route_table_id = "${aws_route_table.external.id}"

}

resource "aws_subnet" "main" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.1.0/24"
    availability_zone = "${var.availability_zone}"
    tags {
      Name = "${terraform.workspace}"
    }
}

resource "aws_subnet" "secondary" {
    vpc_id = "${aws_vpc.main.id}"
    availability_zone = "${var.availability_zone2}"
    cidr_block = "10.0.2.0/24"
    tags {
      Name = "${terraform.workspace}"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = "${aws_vpc.main.id}"
    tags {
      Name = "${terraform.workspace}"
    }
}
