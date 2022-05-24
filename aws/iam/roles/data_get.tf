data "aws_iam_policy_document" "ec2_tag_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:CreateTags", "ec2:DescribeInstances"]
    resources = ["*"]
  }
}
