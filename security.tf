resource "aws_security_group" "dcsworld_security" {
  name        = "dcsworld_security"
  description = "Allow access for game server port, steam"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_egress_rule" "all_out" {
  security_group_id = aws_security_group.dcsworld_security.id
  description       = "Allows unrestricted outbound access"
  cidr_ipv4         = "0.0.0.0/0"
  # from_port         = 0
  # to_port           = 0
  ip_protocol = "-1"
  tags        = { Name = "outbound" }
}

resource "aws_vpc_security_group_ingress_rule" "dcsworld_udp" {
  security_group_id = aws_security_group.dcsworld_security.id
  description       = "Allows whole world access to the dcsworld server port"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 10308 
  to_port           = 10308 
  ip_protocol       = "udp"
  tags              = { Name = "dcsworld UDP" }
}

resource "aws_vpc_security_group_ingress_rule" "dcsworld_tcp" {
  security_group_id = aws_security_group.dcsworld_security.id
  description       = "Allows whole world access to the dcsworld server port"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 10308 
  to_port           = 10308 
  ip_protocol       = "tcp"
  tags              = { Name = "dcsworld TCP" }
}
 

resource "aws_vpc_security_group_ingress_rule" "dcsworld_web" {
  security_group_id = aws_security_group.dcsworld_security.id
  description       = "Allows whole world access to the dcsworld server port"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8088 
  to_port           = 8088 
  ip_protocol       = "tcp"
  tags              = { Name = "dcsworld remote web" }
}
# resource "aws_vpc_security_group_ingress_rule" "steam_query_port" {
#   security_group_id = aws_security_group.dcsworld_security.id
#   description       = "Allows whole world access to the steam query port"
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 2457
#   to_port           = 2457
#   ip_protocol       = "udp"
#   tags              = { Name = "Steam Query" }
# }

resource "aws_vpc_security_group_ingress_rule" "instance_connect_port" {
  security_group_id = aws_security_group.dcsworld_security.id
  description       = "Allows shell access through EC2 instance connect"
  cidr_ipv4         = "${local.my_ip_address}/32"
  from_port         = 3389
  to_port           = 3389
  ip_protocol       = "tcp"
  tags              = { Name = "EC2 Instance Connect" }
}