output "values" {
  sensitive = true
  value = {
    for param_key, param in data.aws_ssm_parameter.this :
    param_key => param.value
  }
}
