output "values" {
  value = {
    for param in data.aws_ssm_parameter.this :
    param.value.name => param.value.value
  }
}