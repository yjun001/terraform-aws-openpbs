provider "aws" {
  # profile = "default"  # fix aws v3 cli vs v4 behaivor
  region  = "us-east-2"
}

#resource "aws_key_pair" "hpc_key_pair" {
#  key_name = "hpc_key_pair"
#  public_key = "${file(var.PUBLIC_KEY_PATH)}"
#}

resource "aws_s3_object" "ansible_script" {
  bucket = var.s3_bucket
  key    = "terraform/hpc-${data.archive_file.ansible_script.output_md5}.zip"
  source = "${path.module}/tmp/ansible_script.zip"
  etag   = data.archive_file.ansible_script.output_md5
}

resource "aws_instance" "hpc_aws_instance" {
  ami                  = "ami-0d5bf08bc8017c83b"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.hpc_iam_profile.name

  for_each = local.local_host_2_ip
  network_interface {
    network_interface_id = aws_network_interface.hpc_interface[each.key].id
    # setup primary network interface
    device_index = 0
  }

  key_name = "aws_hpc_keypair"

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    agent       = false
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(pathexpand("${var.PRIVATE_KEY_PATH}"))
  }

  provisioner "local-exec" {
    command = "echo \"The server's IP address is ${self.private_ip}\""
  }

  # first stage provisioning
  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname ${each.key}"]
  }

  provisioner "file" {
    source      = pathexpand("${var.PRIVATE_KEY_PATH}")
    destination = pathexpand("/home/ubuntu/.ssh/id_rsa")
  }

  # 2nd Stage provisioning
  provisioner "remote-exec" {
    # As the inline parameter can't be empty, so a dummy command is added
    inline = concat(["echo 2nd Stage Provisioning"],
    local.provision_commands["${each.key}" == "master" ? "master" : "nodes"])
  }

  depends_on = [
    aws_network_interface.hpc_interface
  ]

  tags = {
    Name        = "HPC E2 instance ${each.key}"
    OS          = "Ubuntu 20.04"
    Environment = "Sandbox"
    Managed     = "IaC"
  }
}

output "aws_hpc_instance" {
  value = {
    for k, v in aws_instance.hpc_aws_instance : k => v.public_ip
  }
  #value = aws_instance.aws_hpc_instance.public_dns
  depends_on = [aws_instance.hpc_aws_instance]
}
