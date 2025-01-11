variables {
  aws = {
    region  = "us-east-2"
    profile = "terragrunt"
  }

  parameters = ["/homelab/tofu/test/param1", "/homelab/tofu/test/param2"]
}

run "test" {
  command = plan

  assert {
    condition     = length(data.aws_ssm_parameter.this) == 2
    error_message = "Expected 2 parameters, got ${length(data.aws_ssm_parameter.this)}"
  }

  assert {
    condition     = output.values["/homelab/tofu/test/param1"] == "hello"
    error_message = "Parameter value does not match expected value."
  }

  assert {
    condition     = output.values["/homelab/tofu/test/param2"] == "world"
    error_message = "Parameter value does not match expected value."
  }
}
