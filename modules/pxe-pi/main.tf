data "aws_ssm_parameter" "pxeboot_user" {
  name = var.raspberry_pis[var.raspberry_pi].ssh.user_store
}

data "aws_ssm_parameter" "pxeboot_password" {
  name = var.raspberry_pis[var.raspberry_pi].ssh.pass_store
}

resource "ansible_playbook" "setup_iptables" {
  playbook                = "${path.module}/resources/playbooks/setup_iptables.yaml"
  name                    = var.raspberry_pis[var.raspberry_pi].lan.ip
  replayable              = true
  ignore_playbook_failure = false
  extra_vars = {
    ansible_user     = data.aws_ssm_parameter.pxeboot_user.value
    ansible_password = data.aws_ssm_parameter.pxeboot_password.value
  }
}

resource "ansible_playbook" "setup_tftp_server" {
  playbook                = "${path.module}/resources/playbooks/setup_tftp_server.yaml"
  name                    = var.raspberry_pis[var.raspberry_pi].lan.ip
  replayable              = true
  ignore_playbook_failure = false
  extra_vars = {
    ansible_user     = data.aws_ssm_parameter.pxeboot_user.value
    ansible_password = data.aws_ssm_parameter.pxeboot_password.value
  }
}

resource "ansible_playbook" "setup_ipxe" {
  depends_on              = [ansible_playbook.setup_tftp_server]
  playbook                = "${path.module}/resources/playbooks/setup_ipxe.yaml"
  name                    = var.raspberry_pis[var.raspberry_pi].lan.ip
  replayable              = true
  ignore_playbook_failure = false
  extra_vars = {
    ansible_user     = data.aws_ssm_parameter.pxeboot_user.value
    ansible_password = data.aws_ssm_parameter.pxeboot_password.value
    schematics_dir   = "${path.module}/../schematics"
    scripts_dir      = "${path.module}/../scripts"
  }
}
