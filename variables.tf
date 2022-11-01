# The first way: import host data

locals { # this code to parse hosts.ini file to get a map of host and its ip
  raw_lines = [
    for line in compact(split("\n", file("${path.module}/ansible/inventory/hosts.ini"))) :
    line if length(split(" ", line)) > 1 &&
    length(regexall("^#", line)) == 0
    #line
  ]
  lines = [ # leave interesting only line to further parsing
    for line in local.raw_lines :
    compact(split(" ", line))
  ]
  local_host_2_ip = {
    for rec in local.lines :
    rec[0] => split("=", rec[1])[1]
  }
  # output as string of host_2_ip
  string_local_host_2_ip = join(",", formatlist("%s:%s",
  keys(local.local_host_2_ip), values(local.local_host_2_ip)))
}

output "local_host_2_ip_out" {
  value = keys(local.local_host_2_ip)
}

# The second way: import host data
data "external" "datasource_host_2_ip" {
  program = [
    "bash",
    "${path.module}/ansible/paser.sh",
    "${path.module}/ansible/inventory/hosts.ini",
    ""
  ]
}

locals {
  datasource_host_2_ip = data.external.datasource_host_2_ip.result
}

output "datasource_host_2_ip_out" {
  value = keys(local.datasource_host_2_ip)
}

variable "PRIVATE_KEY_PATH" {
  type    = string
  default = "~/projs/aws_hpc_keypair.pem"
}

variable "s3_bucket" {
  type    = string
  default = "s3-hpc-bucket"
}

data "archive_file" "ansible_script" {
  type        = "zip"
  source_dir  = "${path.module}/ansible/"
  output_path = "${path.module}/tmp/ansible_script.zip"
}

locals {
  provision_commands = {
    "nodes" : [
      "echo \"Nodes provisioning:\"",
      "[ -f ~/.ssh/id_rsa ] && rm -f ~/.ssh/id_rsa",
    ],
    "master" : [
      "echo \"Master node provisioning:\"",
      "[ -f ~/.ssh/id_rsa ] && chmod 600 ~/.ssh/id_rsa",
      "sudo apt install -y software-properties-common",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt update && sudo apt -y install unzip awscli ansible",
      "aws s3 cp s3://${var.s3_bucket}/terraform/hpc-${data.archive_file.ansible_script.output_md5}.zip ansible.zip",
      "mkdir ansible && cd ansible && unzip -x ../ansible.zip",
      "ansible-playbook -i inventory/hosts.ini provision.yaml",
    ],
  }
}

variable "ingress_openpbs_ports" {
  type        = list(number)
  description = "list of ingress port for openpbs"
  default     = [17001, 15001, 15002, 15003, 15004]
}