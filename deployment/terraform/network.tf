#
# VPC resources
#
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default" {
  count = length(var.aws_availability_zones)

  availability_zone = var.aws_availability_zones[count.index]

  tags = {
    Name = "Default subnet for ${var.aws_availability_zones[count.index]}"
  }
}
