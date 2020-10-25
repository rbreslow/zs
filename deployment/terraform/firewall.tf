#
# SRCDS security group resources
#
resource "aws_security_group_rule" "srcds_ssh_ingress" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [var.external_access_cidr_block]

  security_group_id = aws_security_group.srcds.id
}

resource "aws_security_group_rule" "srcds_source_ingress" {
  type             = "ingress"
  from_port        = 27015
  to_port          = 27015
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = aws_security_group.srcds.id
}

resource "aws_security_group_rule" "srcds_source_ingress_udp" {
  type             = "ingress"
  from_port        = 27015
  to_port          = 27015
  protocol         = "udp"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = aws_security_group.srcds.id
}

resource "aws_security_group_rule" "srcds_http_egress" {
  type             = "egress"
  from_port        = 80
  to_port          = 80
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = aws_security_group.srcds.id
}

resource "aws_security_group_rule" "srcds_https_egress" {
  type             = "egress"
  from_port        = 443
  to_port          = 443
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = aws_security_group.srcds.id
}
