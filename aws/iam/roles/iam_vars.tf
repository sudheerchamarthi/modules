variable "iam_s3_policy_json" {
  default = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": ["ec2:Describe*"],
            "Resource": ["*"]
        }
    ]
}

EOF

}

variable "base_profile" {
  default = "base_profile"
}

variable "base_role" {
  default = "ec2_basic_role"
}

variable "base_policy" {
  default = "ec2_describe_policy"
}
