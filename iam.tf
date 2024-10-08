resource "aws_iam_instance_profile" "dcsworld_profile" {
  name = "dcsworld_profile"
  role = aws_iam_role.dcsworld_role.name
}

resource "aws_iam_role" "dcsworld_role" {
  name               = "dcsworld_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# data "aws_iam_policy_document" "s3_access" {
#   statement {
#     effect    = "Allow"
#     actions   = ["s3:*"]
#     resources = [aws_s3_bucket.bucket.arn, "${aws_s3_bucket.bucket.arn}/*"]
#   }
# }

# resource "aws_iam_role_policy" "s3_access" {
#   name   = "s3_access"
#   role   = aws_iam_role.dcsworld_role.name
#   policy = data.aws_iam_policy_document.s3_access.json
# }

data "aws_route53_zone" "rgrs_zone" {
  name = var.hosted_zone

}

data "aws_iam_policy_document" "r53_access" {
  statement {
    effect    = "Allow"
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = [data.aws_route53_zone.rgrs_zone.arn]
  }
  statement {
    effect    = "Allow"
    actions   = ["route53:ListHostedZones"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "r53_access" {
  name   = "r53_access"
  role   = aws_iam_role.dcsworld_role.name
  policy = data.aws_iam_policy_document.r53_access.json
}

# data "aws_iam_policy_document" "self_access" {
#   statement {
#     effect    = "Allow"
#     actions   = ["ec2:*"]
#     resources = [aws_instance.dcsworld.arn]
#   }
#   statement {
#     effect    = "Allow"
#     actions   = ["ec2:DescribeInstances"]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_role_policy" "self_access" {
#   name   = "self_access"
#   role   = aws_iam_role.dcsworld_role.name
#   policy = data.aws_iam_policy_document.self_access.json
# }



resource "aws_iam_role_policy_attachment" "cloudwatch_access" {
  role       = aws_iam_role.dcsworld_role.name
  policy_arn = data.aws_iam_policy.cloudwatch_policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm_managed" {
  role = aws_iam_role.dcsworld_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}