resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${aws_subnet.main.id}", "${aws_subnet.secondary.id}"]

  tags {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 1
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.6.17"
  instance_class       = "db.t1.micro"
  name                 = "test"
  username             = "test"
  password             = "test"
  db_subnet_group_name = "${aws_db_subnet_group.default.name}"
  parameter_group_name = "default.mysql5.6"
}
