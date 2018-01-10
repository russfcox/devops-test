resource "aws_db_subnet_group" "default" {
  name       = "main-${terraform.workspace}"
  subnet_ids = ["${aws_subnet.main.id}", "${aws_subnet.secondary.id}"]

  tags {
    Name = "${terraform.workspace} DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  name                 = "db-${terraform.workspace}"
  identifier           = "${var.app-name}-${terraform.workspace}"
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
  final_snapshot_identifier = "dbsnap-deleteme-${terraform.workspace}"
  apply_immediately = true
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
  publicly_accessible = true
  # parameter_group_name = "default.mysql5.6"
}
