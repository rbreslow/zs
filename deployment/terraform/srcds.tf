#
# SRCDS resources
#
resource "aws_security_group" "srcds" {
  vpc_id = aws_default_vpc.default.id

  tags = {
    Name        = "sgSRCDS",
    Project     = var.project,
    Environment = var.environment
  }
}

resource "aws_network_interface_sg_attachment" "srcds" {
  security_group_id    = aws_security_group.srcds.id
  network_interface_id = aws_instance.srcds.primary_network_interface_id
}

resource "aws_instance" "srcds" {
  ami                         = var.srcds_ami
  availability_zone           = var.aws_availability_zones[0]
  ebs_optimized               = true
  instance_type               = var.srcds_instance_type
  key_name                    = var.aws_key_name
  monitoring                  = true
  subnet_id                   = aws_default_subnet.default[0].id
  associate_public_ip_address = true

  tags = {
    Name        = "SRCDS",
    Project     = var.project,
    Environment = var.environment
  }
}
