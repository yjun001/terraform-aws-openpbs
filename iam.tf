resource "aws_iam_role" "hpc_iam_role" {
  name               = "hpc-iam-profile"
  assume_role_policy = file("${path.module}/role.json")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "hpc_iam_profile" {
  name = "hpc-iam-profile"
  role = aws_iam_role.hpc_iam_role.name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "hpc_iam_policy" {
  name        = "hpc-iam-policy"
  description = "HPC IAM Policy"
  policy      = file("${path.module}/policy.json")
}

resource "aws_iam_policy_attachment" "attach" {
  name       = "hpc-attach-policy"
  roles      = ["${aws_iam_role.hpc_iam_role.name}"]
  policy_arn = aws_iam_policy.hpc_iam_policy.arn
}