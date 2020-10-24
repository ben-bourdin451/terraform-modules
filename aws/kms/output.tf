output "alias_arn" {
  value = aws_kms_alias.cmk.arn
}

output "alias_target_key_arn" {
  value = aws_kms_alias.cmk.target_key_arn
}

output "key_id" {
  value = aws_kms_key.cmk.key_id
}

output "alias_key_id" {
  value = aws_kms_alias.cmk.target_key_id
}

