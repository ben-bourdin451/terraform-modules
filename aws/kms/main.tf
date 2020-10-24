data "aws_caller_identity" "current" {}

resource "aws_kms_key" "cmk" {
  deletion_window_in_days = var.key_deletion_window
  enable_key_rotation     = true
  description             = var.key_description

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "KeyPolicy",
  "Statement": [
    {
      "Sid": "AllowAccessForKeyAdministrators",
      "Effect": "Allow",
      "Principal": {
        "AWS": ${local.administrator_arn_list}
      },
      "Action": [
        "kms:CancelKeyDeletion",
        "kms:Create*",
        "kms:Delete*",
        "kms:Describe*",
        "kms:Disable*",
        "kms:Enable*",
        "kms:Get*",
        "kms:List*",
        "kms:Put*",
        "kms:ScheduleKeyDeletion",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:Update*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowDescribeAndList",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": [
        "kms:Describe*",
        "kms:Get*",
        "kms:List*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowUseOfTheKey",
      "Effect": "Allow",
      "Principal": ${local.principal_values},
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*"
      ],
      "Resource": "*"
    }
  ]
}
EOF

  tags = {
    Terraform = "true"
  }
}

resource "aws_kms_alias" "cmk" {
  name = format("alias/%s", var.key_alias)
  target_key_id = aws_kms_key.cmk.key_id
}
