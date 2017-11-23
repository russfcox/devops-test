data "aws_route53_zone" "selected" {
  name = "russcox.co.uk."
  private_zone = false
}

resource "aws_route53_record" "frontend" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name = "app-${terraform.workspace}.${data.aws_route53_zone.selected.name}"
  type = "CNAME"
  ttl  = "60"
  records = ["${aws_elb.test-http.dns_name}"]
}
