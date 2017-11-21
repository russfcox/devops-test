resource "aws_db_subnet_group" "default" {
  name       = "main-${var.env-name}"
  subnet_ids = ["${aws_subnet.main.id}", "${aws_subnet.secondary.id}"]

  tags {
    Name = "${var.env-name} DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  name                 = "db-${var.env-name}"
  allocated_storage    = 5
  storage_type         = "standard"
  engine               = "mysql"
  engine_version       = "5.7.19"
  instance_class       = "db.t2.micro"
  name                 = "test"
  username             = "test"
  password             = "testpassword"
  db_subnet_group_name = "${aws_db_subnet_group.default.name}"
  skip_final_snapshot = true
  final_snapshot_identifier = "dbsnap-deleteme-${var.env-name}"
  apply_immediately = true
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
  # parameter_group_name = "default.mysql5.6"
}
