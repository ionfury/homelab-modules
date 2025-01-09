data "aws_ssm_parameter" "this" {
  for_each = var.parameters
  name     = each.value.name
}
