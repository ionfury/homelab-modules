data "aws_ssm_parameter" "this" {
  for_each = toset(var.parameters)
  name     = each.value
}
