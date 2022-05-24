resource "aws_iam_instance_profile" "base_profile" {
  name = var.base_profile
  role = aws_iam_role.ec2_basic_ro.name
}

resource "aws_iam_role" "ec2_basic_ro" {
  name = var.base_role
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com","ecs.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

# resource "aws_iam_policy" "ec2_describe" {
resource "aws_iam_role_policy" "ec2_describe" {
  name = "ec2_basic_policy"

  # path        = "/"
  role = aws_iam_role.ec2_basic_ro.id

  # description = "Allow ec2:Describe"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*",
        "ecr:GetAuthorizationToken",
        "ecr:DescribeRepositories",
        "sts:AssumeRole",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "s3_policy" {
  name   = "s3_common_bucket_log_policy"
  role   = aws_iam_role.ec2_basic_ro.name
  policy = var.iam_s3_policy_json
  # policy = "${data.aws_iam_policy_document.s3_policy.json}"
}

resource "aws_iam_role_policy" "ec2_tag_policy" {
  name   = "ec2_tag_policy"
  role   = aws_iam_role.ec2_basic_ro.name
  policy = data.aws_iam_policy_document.ec2_tag_policy.json
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  policy_arn = data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
  role       = aws_iam_role.ec2_basic_ro.name
}

output "ec2_base_instance_profile" {
  value = aws_iam_instance_profile.base_profile.name
}

output "ec2_base_instance_role" {
  value = aws_iam_role.ec2_basic_ro.name
}

output "ec2_base_instance_arn" {
  value = aws_iam_role.ec2_basic_ro.arn
}
