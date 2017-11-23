output "app-endpoint" {
  value = "${aws_elb.test-http.dns_name}"
}
output "dns-name" { value = "${aws_route53_record.frontend.fqdn}" }
output "dbhost" { value = "${aws_db_instance.default.address}" }
output "dbname" { value = "${aws_db_instance.default.name}" }
output "dbuser" { value = "${aws_db_instance.default.username}" }
