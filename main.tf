resource "aws_instance" "dcsworld" {
  ami           = data.aws_ami.windows.id
  instance_type = var.instance_type

  # instance_market_options {
  #   market_type = "spot"
  #   spot_options {
  #     max_price                      = 0.03
  #     instance_interruption_behavior = "stop"
  #     spot_instance_type             = "persistent"
  #   }
  # }

    root_block_device {
      volume_size = 200
      volume_type = "gp3"
    }
  tags = {
    Name = "dcsworldServer"
    # env_s3bucket = aws_s3_bucket.bucket.id
    dns_hostname = "dcsworld"
    dns_zone     = var.hosted_zone
  }

  vpc_security_group_ids = [aws_security_group.dcsworld_security.id]
  iam_instance_profile   = aws_iam_instance_profile.dcsworld_profile.id

  user_data_base64            = filebase64("${path.module}/userdata.txt") 
  user_data_replace_on_change = true
  # get_password_data = true
}

resource "aws_route53_record" "dcsworld" {
  type = "A"
  zone_id = data.aws_route53_zone.rgrs_zone.id
  name = "dcsworld"
  ttl = 300
  records = [aws_instance.dcsworld.public_ip]
}
