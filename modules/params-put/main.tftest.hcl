variables {
  aws = {
    region  = "us-east-2"
    profile = "terragrunt"
  }

  parameters = {
    "param1" = {
      name        = "/test/params-put/param1"
      description = "Example parameter 1"
      type        = "String"
      value       = "Hello, world!"
    }
    "param2" = {
      name        = "/test/params-put/param2"
      description = "Example parameter 2"
      type        = "String"
      value       = "Goodbye, world!"
    }
  }
}

run "test" {
  command = plan
  assert {
    condition     = aws_ssm_parameter.this["param1"].value == "Hello, world!"
    error_message = "Parameter value does not match expected value."
  }
  assert {
    condition     = aws_ssm_parameter.this["param2"].value == "Goodbye, world!"
    error_message = "Parameter value does not match expected value."
  }
}

