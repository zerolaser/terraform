resource "aws_iam_policy" "policy" {
    name = "Ec2FullAccess_test"
    path ="/"
    description =" EC2 Full Access"
    policy = <<EOF
   {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*",
        "s3:*",
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

output "policy" {
    value = "${aws_iam_policy.policy.name}"
}

output "policy_arn" {
    value = "${aws_iam_policy.policy.arn}"
}
