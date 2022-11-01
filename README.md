# AWS HPC EC2 cluster instances - create by **terraform**

Create three aws HPC EC2 cluster instances by using [terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs), base on this [hosts file](https://github.com/yjun-001/multi-aws-instances/blob/f5afca22f5b18cb27f1be86189f0d34767730d49/hosts.ini)
https://github.com/yjun-001/multi-aws-instances/blob/f5afca22f5b18cb27f1be86189f0d34767730d49/hosts.ini#L1-L14


### Prerequisite Package and its environment Setup (Windows 10 Desktop)
- Install Windows WSL2 & Ubuntu from Microsoft Store
- Install awscli inside WSL
  - sudo apt install aws
- Install [terraform](https://www.terraform.io/downloads)
  - download **terraform** linux binary and unzip it and move into /usr/local/bin
 
### Reposity Usage:
- Clone [this repositry](https://github.com/yjun-001/multi-aws-instances.git)
- following commands are available:
    - **terraform init**
    - **terraform plan**
    - **terraform graph --draw-cycle** (see below graph)
    - **terraform apply**
      - multiple aws instances should be created by applying successfully
    - **terraform destroy**

### repository entities relationship created by terraform graph
![Alt text](https://github.com/yjun-001/multi-aws-instances/blob/9a1c8a2e89a58682e8a4a92945c680accbe440eb/image/graphviz.svg)

### This repository will do 
- create an AWS VPC with cidr_block = **"10.0.0.0/16"**
- create an AWS Public subnet with cidr_block = **10.0.1.0/24"** # 254 IP addresses available in this subnet
- create an AWS Internat Gateway(IG) and route table (RT)
- create an AWS Security Group (SG), and allow ssh incoming traffic at port 22
- create a three-nodes of EC2 cluster instances, 
  - assign each instances a static private IP. which defined in hosts file above. this IP address is to use as the primary address of private subnet, instead of the default assigned DHCP address, [DHCP Issues](https://stackoverflow.com/questions/42666396/terraform-correctly-assigning-a-static-private-ip-to-newly-created-instance)
  - setup each hostname as well according to hosts file.
  - update private ssh key in master node instance, so it can ssh other nodes without password

### Code In Action and its output:
#### **terraform apply:**
```bash
>terraform apply
data.external.datasource_host_2_ip: Reading...
data.external.datasource_host_2_ip: Read complete after 0s [id=-]

Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.hpc_aws_instance["master"] will be created
  + resource "aws_instance" "hpc_aws_instance" {
      + ami                                  = "ami-0d5bf08bc8017c83b"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = "aws_hpc_keypair"
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Environment" = "Sandbox"
          + "Managed"     = "IaC"
          + "Name"        = "HPC E2 instance master"
          + "OS"          = "Ubuntu 20.04"
        }
      + tags_all                             = {
          + "Environment" = "Sandbox"
          + "Managed"     = "IaC"
          + "Name"        = "HPC E2 instance master"
          + "OS"          = "Ubuntu 20.04"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification {
          + capacity_reservation_preference = (known after apply)

          + capacity_reservation_target {
              + capacity_reservation_id                 = (known after apply)
              + capacity_reservation_resource_group_arn = (known after apply)
            }
        }

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + enclave_options {
          + enabled = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + maintenance_options {
          + auto_recovery = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
          + instance_metadata_tags      = (known after apply)
        }

      + network_interface {
          + delete_on_termination = false
          + device_index          = 0
          + network_card_index    = 0
          + network_interface_id  = (known after apply)
        }

      + private_dns_name_options {
          + enable_resource_name_dns_a_record    = (known after apply)
          + enable_resource_name_dns_aaaa_record = (known after apply)
          + hostname_type                        = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_instance.hpc_aws_instance["node1"] will be created
  + resource "aws_instance" "hpc_aws_instance" {
      + ami                                  = "ami-0d5bf08bc8017c83b"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = "aws_hpc_keypair"
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Environment" = "Sandbox"
          + "Managed"     = "IaC"
          + "Name"        = "HPC E2 instance node1"
          + "OS"          = "Ubuntu 20.04"
        }
      + tags_all                             = {
          + "Environment" = "Sandbox"
          + "Managed"     = "IaC"
          + "Name"        = "HPC E2 instance node1"
          + "OS"          = "Ubuntu 20.04"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification {
          + capacity_reservation_preference = (known after apply)

          + capacity_reservation_target {
              + capacity_reservation_id                 = (known after apply)
              + capacity_reservation_resource_group_arn = (known after apply)
            }
        }

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + enclave_options {
          + enabled = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + maintenance_options {
          + auto_recovery = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
          + instance_metadata_tags      = (known after apply)
        }

      + network_interface {
          + delete_on_termination = false
          + device_index          = 0
          + network_card_index    = 0
          + network_interface_id  = (known after apply)
        }

      + private_dns_name_options {
          + enable_resource_name_dns_a_record    = (known after apply)
          + enable_resource_name_dns_aaaa_record = (known after apply)
          + hostname_type                        = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_instance.hpc_aws_instance["node2"] will be created
  + resource "aws_instance" "hpc_aws_instance" {
      + ami                                  = "ami-0d5bf08bc8017c83b"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = "aws_hpc_keypair"
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Environment" = "Sandbox"
          + "Managed"     = "IaC"
          + "Name"        = "HPC E2 instance node2"
          + "OS"          = "Ubuntu 20.04"
        }
      + tags_all                             = {
          + "Environment" = "Sandbox"
          + "Managed"     = "IaC"
          + "Name"        = "HPC E2 instance node2"
          + "OS"          = "Ubuntu 20.04"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification {
          + capacity_reservation_preference = (known after apply)

          + capacity_reservation_target {
              + capacity_reservation_id                 = (known after apply)
              + capacity_reservation_resource_group_arn = (known after apply)
            }
        }

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + enclave_options {
          + enabled = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + maintenance_options {
          + auto_recovery = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
          + instance_metadata_tags      = (known after apply)
        }

      + network_interface {
          + delete_on_termination = false
          + device_index          = 0
          + network_card_index    = 0
          + network_interface_id  = (known after apply)
        }

      + private_dns_name_options {
          + enable_resource_name_dns_a_record    = (known after apply)
          + enable_resource_name_dns_aaaa_record = (known after apply)
          + hostname_type                        = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_internet_gateway.hpc_igw will be created
  + resource "aws_internet_gateway" "hpc_igw" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags     = {
          + "Name" = "hpc-igw"
        }
      + tags_all = {
          + "Name" = "hpc-igw"
        }
      + vpc_id   = (known after apply)
    }

  # aws_network_interface.hpc_interface["master"] will be created
  + resource "aws_network_interface" "hpc_interface" {
      + arn                       = (known after apply)
      + id                        = (known after apply)
      + interface_type            = (known after apply)
      + ipv4_prefix_count         = (known after apply)
      + ipv4_prefixes             = (known after apply)
      + ipv6_address_count        = (known after apply)
      + ipv6_address_list         = (known after apply)
      + ipv6_address_list_enabled = false
      + ipv6_addresses            = (known after apply)
      + ipv6_prefix_count         = (known after apply)
      + ipv6_prefixes             = (known after apply)
      + mac_address               = (known after apply)
      + outpost_arn               = (known after apply)
      + owner_id                  = (known after apply)
      + private_dns_name          = (known after apply)
      + private_ip                = (known after apply)
      + private_ip_list           = (known after apply)
      + private_ip_list_enabled   = false
      + private_ips               = [
          + "10.0.1.100",
        ]
      + private_ips_count         = (known after apply)
      + security_groups           = (known after apply)
      + source_dest_check         = true
      + subnet_id                 = (known after apply)
      + tags_all                  = (known after apply)

      + attachment {
          + attachment_id = (known after apply)
          + device_index  = (known after apply)
          + instance      = (known after apply)
        }
    }

  # aws_network_interface.hpc_interface["node1"] will be created
  + resource "aws_network_interface" "hpc_interface" {
      + arn                       = (known after apply)
      + id                        = (known after apply)
      + interface_type            = (known after apply)
      + ipv4_prefix_count         = (known after apply)
      + ipv4_prefixes             = (known after apply)
      + ipv6_address_count        = (known after apply)
      + ipv6_address_list         = (known after apply)
      + ipv6_address_list_enabled = false
      + ipv6_addresses            = (known after apply)
      + ipv6_prefix_count         = (known after apply)
      + ipv6_prefixes             = (known after apply)
      + mac_address               = (known after apply)
      + outpost_arn               = (known after apply)
      + owner_id                  = (known after apply)
      + private_dns_name          = (known after apply)
      + private_ip                = (known after apply)
      + private_ip_list           = (known after apply)
      + private_ip_list_enabled   = false
      + private_ips               = [
          + "10.0.1.101",
        ]
      + private_ips_count         = (known after apply)
      + security_groups           = (known after apply)
      + source_dest_check         = true
      + subnet_id                 = (known after apply)
      + tags_all                  = (known after apply)

      + attachment {
          + attachment_id = (known after apply)
          + device_index  = (known after apply)
          + instance      = (known after apply)
        }
    }

  # aws_network_interface.hpc_interface["node2"] will be created
  + resource "aws_network_interface" "hpc_interface" {
      + arn                       = (known after apply)
      + id                        = (known after apply)
      + interface_type            = (known after apply)
      + ipv4_prefix_count         = (known after apply)
      + ipv4_prefixes             = (known after apply)
      + ipv6_address_count        = (known after apply)
      + ipv6_address_list         = (known after apply)
      + ipv6_address_list_enabled = false
      + ipv6_addresses            = (known after apply)
      + ipv6_prefix_count         = (known after apply)
      + ipv6_prefixes             = (known after apply)
      + mac_address               = (known after apply)
      + outpost_arn               = (known after apply)
      + owner_id                  = (known after apply)
      + private_dns_name          = (known after apply)
      + private_ip                = (known after apply)
      + private_ip_list           = (known after apply)
      + private_ip_list_enabled   = false
      + private_ips               = [
          + "10.0.1.102",
        ]
      + private_ips_count         = (known after apply)
      + security_groups           = (known after apply)
      + source_dest_check         = true
      + subnet_id                 = (known after apply)
      + tags_all                  = (known after apply)

      + attachment {
          + attachment_id = (known after apply)
          + device_index  = (known after apply)
          + instance      = (known after apply)
        }
    }

  # aws_route_table.hpc_public_route_table will be created
  + resource "aws_route_table" "hpc_public_route_table" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + carrier_gateway_id         = ""
              + cidr_block                 = "0.0.0.0/0"
              + core_network_arn           = ""
              + destination_prefix_list_id = ""
              + egress_only_gateway_id     = ""
              + gateway_id                 = (known after apply)
              + instance_id                = ""
              + ipv6_cidr_block            = ""
              + local_gateway_id           = ""
              + nat_gateway_id             = ""
              + network_interface_id       = ""
              + transit_gateway_id         = ""
              + vpc_endpoint_id            = ""
              + vpc_peering_connection_id  = ""
            },
        ]
      + tags             = {
          + "Name" = "hpc-public-route-table"
        }
      + tags_all         = {
          + "Name" = "hpc-public-route-table"
        }
      + vpc_id           = (known after apply)
    }

  # aws_route_table_association.hpc_route_table_public_subnet-1 will be created
  + resource "aws_route_table_association" "hpc_route_table_public_subnet-1" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # aws_security_group.allow_ssh_sg will be created
  + resource "aws_security_group" "allow_ssh_sg" {
      + arn                    = (known after apply)
      + description            = "allow ssh inbond traffic"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "name" = "allowed_ssh"
        }
      + tags_all               = {
          + "name" = "allowed_ssh"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_subnet.hpc_subnet will be created
  + resource "aws_subnet" "hpc_subnet" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = (known after apply)
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "hpc_subnet"
        }
      + tags_all                                       = {
          + "Name" = "hpc_subnet"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_vpc.hpc_vpc will be created
  + resource "aws_vpc" "hpc_vpc" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_classiclink                   = (known after apply)
      + enable_classiclink_dns_support       = (known after apply)
      + enable_dns_hostnames                 = true
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Name" = "hpc_vpc"
        }
      + tags_all                             = {
          + "Name" = "hpc_vpc"
        }
    }

Plan: 12 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + aws_hpc_instance         = {
      + master = (known after apply)
      + node1  = (known after apply)
      + node2  = (known after apply)
    }
  + datasource_host_2_ip_out = [
      + "master",
      + "node1",
      + "node2",
    ]
  + local_host_2_ip_out      = [
      + "master",
      + "node1",
      + "node2",
    ]

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_vpc.hpc_vpc: Creating...
aws_vpc.hpc_vpc: Still creating... [10s elapsed]
aws_vpc.hpc_vpc: Creation complete after 12s [id=vpc-035315ec2007e9693]
aws_internet_gateway.hpc_igw: Creating...
aws_subnet.hpc_subnet: Creating...
aws_security_group.allow_ssh_sg: Creating...
aws_internet_gateway.hpc_igw: Creation complete after 1s [id=igw-031d12da2d12f84cb]
aws_route_table.hpc_public_route_table: Creating...
aws_route_table.hpc_public_route_table: Creation complete after 1s [id=rtb-068b4facca57e48b9]
aws_security_group.allow_ssh_sg: Creation complete after 2s [id=sg-04978ad4d5d672075]
aws_subnet.hpc_subnet: Still creating... [10s elapsed]
aws_subnet.hpc_subnet: Creation complete after 11s [id=subnet-070ebdf9f806b83f5]
aws_route_table_association.hpc_route_table_public_subnet-1: Creating...
aws_network_interface.hpc_interface["node1"]: Creating...
aws_network_interface.hpc_interface["node2"]: Creating...
aws_network_interface.hpc_interface["master"]: Creating...
aws_route_table_association.hpc_route_table_public_subnet-1: Creation complete after 0s [id=rtbassoc-0c36eabc085cb8beb]
aws_network_interface.hpc_interface["node2"]: Creation complete after 1s [id=eni-0db98742b2257297d]
aws_network_interface.hpc_interface["node1"]: Creation complete after 1s [id=eni-02fb90151af44d25e] 
aws_network_interface.hpc_interface["master"]: Creation complete after 1s [id=eni-0b7663dd7bf17a975]aws_instance.hpc_aws_instance["node1"]: Creating...
aws_instance.hpc_aws_instance["node2"]: Creating...
aws_instance.hpc_aws_instance["master"]: Creating...
aws_instance.hpc_aws_instance["node1"]: Still creating... [10s elapsed]
aws_instance.hpc_aws_instance["node2"]: Still creating... [10s elapsed]
aws_instance.hpc_aws_instance["master"]: Still creating... [10s elapsed]
aws_instance.hpc_aws_instance["node2"]: Still creating... [20s elapsed]
aws_instance.hpc_aws_instance["master"]: Still creating... [20s elapsed]
aws_instance.hpc_aws_instance["node1"]: Still creating... [20s elapsed]
aws_instance.hpc_aws_instance["master"]: Still creating... [30s elapsed]
aws_instance.hpc_aws_instance["node2"]: Still creating... [30s elapsed]
aws_instance.hpc_aws_instance["node1"]: Still creating... [30s elapsed]
aws_instance.hpc_aws_instance["node1"]: Provisioning with 'local-exec'...
aws_instance.hpc_aws_instance["node1"] (local-exec): Executing: ["/bin/sh" "-c" "echo \"The server's IP address is 10.0.1.101\""]
aws_instance.hpc_aws_instance["node1"] (local-exec): The server's IP address is 10.0.1.101
aws_instance.hpc_aws_instance["node1"]: Provisioning with 'remote-exec'...
aws_instance.hpc_aws_instance["node1"] (remote-exec): Connecting to remote host via SSH...
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Host: 3.19.143.186
aws_instance.hpc_aws_instance["node1"] (remote-exec):   User: ubuntu
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Password: false
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Private key: true
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Certificate: false
aws_instance.hpc_aws_instance["node1"] (remote-exec):   SSH Agent: false
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Checking Host Key: false
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Target Platform: unix
aws_instance.hpc_aws_instance["master"]: Provisioning with 'local-exec'...
aws_instance.hpc_aws_instance["master"] (local-exec): Executing: ["/bin/sh" "-c" "echo \"The server's IP address is 10.0.1.100\""]
aws_instance.hpc_aws_instance["master"] (local-exec): The server's IP address is 10.0.1.100
aws_instance.hpc_aws_instance["master"]: Provisioning with 'remote-exec'...
aws_instance.hpc_aws_instance["master"] (remote-exec): Connecting to remote host via SSH...
aws_instance.hpc_aws_instance["master"] (remote-exec):   Host: 18.188.162.188
aws_instance.hpc_aws_instance["master"] (remote-exec):   User: ubuntu
aws_instance.hpc_aws_instance["master"] (remote-exec):   Password: false
aws_instance.hpc_aws_instance["master"] (remote-exec):   Private key: true
aws_instance.hpc_aws_instance["master"] (remote-exec):   Certificate: false
aws_instance.hpc_aws_instance["master"] (remote-exec):   SSH Agent: false
aws_instance.hpc_aws_instance["master"] (remote-exec):   Checking Host Key: false
aws_instance.hpc_aws_instance["master"] (remote-exec):   Target Platform: unix
aws_instance.hpc_aws_instance["node2"]: Provisioning with 'local-exec'...
aws_instance.hpc_aws_instance["node2"] (local-exec): Executing: ["/bin/sh" "-c" "echo \"The server's IP address is 10.0.1.102\""]
aws_instance.hpc_aws_instance["node2"] (local-exec): The server's IP address is 10.0.1.102
aws_instance.hpc_aws_instance["node2"]: Provisioning with 'remote-exec'...
aws_instance.hpc_aws_instance["node2"] (remote-exec): Connecting to remote host via SSH...
aws_instance.hpc_aws_instance["node2"] (remote-exec):   Host: 3.139.62.104
aws_instance.hpc_aws_instance["node2"] (remote-exec):   User: ubuntu
aws_instance.hpc_aws_instance["node2"] (remote-exec):   Password: false
aws_instance.hpc_aws_instance["node2"] (remote-exec):   Private key: true
aws_instance.hpc_aws_instance["node2"] (remote-exec):   Certificate: false
aws_instance.hpc_aws_instance["node2"] (remote-exec):   SSH Agent: false
aws_instance.hpc_aws_instance["node2"] (remote-exec):   Checking Host Key: false
aws_instance.hpc_aws_instance["node2"] (remote-exec):   Target Platform: unix
aws_instance.hpc_aws_instance["node2"] (remote-exec): Connected!
aws_instance.hpc_aws_instance["node1"] (remote-exec): Connecting to remote host via SSH...
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Host: 3.19.143.186
aws_instance.hpc_aws_instance["node1"] (remote-exec):   User: ubuntu
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Password: false
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Private key: true
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Certificate: false
aws_instance.hpc_aws_instance["node1"] (remote-exec):   SSH Agent: false
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Checking Host Key: false
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Target Platform: unix
aws_instance.hpc_aws_instance["master"] (remote-exec): Connecting to remote host via SSH...
aws_instance.hpc_aws_instance["master"] (remote-exec):   Host: 18.188.162.188
aws_instance.hpc_aws_instance["master"] (remote-exec):   User: ubuntu
aws_instance.hpc_aws_instance["master"] (remote-exec):   Password: false
aws_instance.hpc_aws_instance["master"] (remote-exec):   Private key: true
aws_instance.hpc_aws_instance["master"] (remote-exec):   Certificate: false
aws_instance.hpc_aws_instance["master"] (remote-exec):   SSH Agent: false
aws_instance.hpc_aws_instance["master"] (remote-exec):   Checking Host Key: false
aws_instance.hpc_aws_instance["master"] (remote-exec):   Target Platform: unix
aws_instance.hpc_aws_instance["node1"] (remote-exec): Connected!
aws_instance.hpc_aws_instance["master"] (remote-exec): Connected!
aws_instance.hpc_aws_instance["node2"]: Provisioning with 'file'...
aws_instance.hpc_aws_instance["node1"]: Provisioning with 'file'...
aws_instance.hpc_aws_instance["master"]: Still creating... [40s elapsed]
aws_instance.hpc_aws_instance["node2"]: Still creating... [40s elapsed]
aws_instance.hpc_aws_instance["node1"]: Still creating... [40s elapsed]
aws_instance.hpc_aws_instance["node2"]: Provisioning with 'remote-exec'...
aws_instance.hpc_aws_instance["node2"] (remote-exec): Connecting to remote host via SSH...
aws_instance.hpc_aws_instance["node2"] (remote-exec):   Host: 3.139.62.104
aws_instance.hpc_aws_instance["node2"] (remote-exec):   User: ubuntu
aws_instance.hpc_aws_instance["node2"] (remote-exec):   Password: false
aws_instance.hpc_aws_instance["node2"] (remote-exec):   Private key: true
aws_instance.hpc_aws_instance["node2"] (remote-exec):   Certificate: false
aws_instance.hpc_aws_instance["node2"] (remote-exec):   SSH Agent: false
aws_instance.hpc_aws_instance["node2"] (remote-exec):   Checking Host Key: false
aws_instance.hpc_aws_instance["node2"] (remote-exec):   Target Platform: unix
aws_instance.hpc_aws_instance["node2"] (remote-exec): Connected!
aws_instance.hpc_aws_instance["node1"]: Provisioning with 'remote-exec'...
aws_instance.hpc_aws_instance["node1"] (remote-exec): Connecting to remote host via SSH...
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Host: 3.19.143.186
aws_instance.hpc_aws_instance["node1"] (remote-exec):   User: ubuntu
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Password: false
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Private key: true
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Certificate: false
aws_instance.hpc_aws_instance["node1"] (remote-exec):   SSH Agent: false
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Checking Host Key: false
aws_instance.hpc_aws_instance["node1"] (remote-exec):   Target Platform: unix
aws_instance.hpc_aws_instance["master"]: Provisioning with 'file'...
aws_instance.hpc_aws_instance["node2"] (remote-exec): 2nd Stage Provisioning
aws_instance.hpc_aws_instance["node2"] (remote-exec): Nodes provisioning:
aws_instance.hpc_aws_instance["node1"] (remote-exec): Connected!
aws_instance.hpc_aws_instance["node2"]: Creation complete after 42s [id=i-0dab989e56873c6f0]
aws_instance.hpc_aws_instance["node1"] (remote-exec): 2nd Stage Provisioning
aws_instance.hpc_aws_instance["node1"] (remote-exec): Nodes provisioning:
aws_instance.hpc_aws_instance["node1"]: Creation complete after 43s [id=i-0c22b1f93fdcc7736]
aws_instance.hpc_aws_instance["master"]: Provisioning with 'remote-exec'...
aws_instance.hpc_aws_instance["master"] (remote-exec): Connecting to remote host via SSH...
aws_instance.hpc_aws_instance["master"] (remote-exec):   Host: 18.188.162.188
aws_instance.hpc_aws_instance["master"] (remote-exec):   User: ubuntu
aws_instance.hpc_aws_instance["master"] (remote-exec):   Password: false
aws_instance.hpc_aws_instance["master"] (remote-exec):   Private key: true
aws_instance.hpc_aws_instance["master"] (remote-exec):   Certificate: false
aws_instance.hpc_aws_instance["master"] (remote-exec):   SSH Agent: false
aws_instance.hpc_aws_instance["master"] (remote-exec):   Checking Host Key: false
aws_instance.hpc_aws_instance["master"] (remote-exec):   Target Platform: unix
aws_instance.hpc_aws_instance["master"] (remote-exec): Connected!
aws_instance.hpc_aws_instance["master"] (remote-exec): 2nd Stage Provisioning
aws_instance.hpc_aws_instance["master"] (remote-exec): Master node provisioning:
aws_instance.hpc_aws_instance["master"]: Creation complete after 44s [id=i-0f968c48404fbcff4]

Apply complete! Resources: 12 added, 0 changed, 0 destroyed.

Outputs:

aws_hpc_instance = {
  "master" = "18.188.162.188"
  "node1" = "3.19.143.186"
  "node2" = "3.139.62.104"
}
datasource_host_2_ip_out = tolist([
  "master",
  "node1",
  "node2",
])
local_host_2_ip_out = [
  "master",
  "node1",
  "node2",
]
```
#### Login master node
```bash
>ssh -i ../../aws_hpc_keypair.pem ubuntu@18.188.162.188
Welcome to Ubuntu 20.04.5 LTS (GNU/Linux 5.15.0-1019-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri Oct 28 17:26:54 UTC 2022

  System load:  0.0               Processes:             98
  Usage of /:   19.9% of 7.57GB   Users logged in:       0
  Memory usage: 24%               IPv4 address for eth0: 10.0.1.100
  Swap usage:   0%


0 updates can be applied immediately.


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
New release '22.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Fri Oct 28 17:22:24 2022 from 68.40.206.242
ubuntu@master:~$ hostname
master

```

#### Terraform destroy
```bash
> terraform destroy
data.external.datasource_host_2_ip: Reading...
data.external.datasource_host_2_ip: Read complete after 0s [id=-]
aws_vpc.hpc_vpc: Refreshing state... [id=vpc-035315ec2007e9693]
aws_internet_gateway.hpc_igw: Refreshing state... [id=igw-031d12da2d12f84cb]
aws_subnet.hpc_subnet: Refreshing state... [id=subnet-070ebdf9f806b83f5]
aws_security_group.allow_ssh_sg: Refreshing state... [id=sg-04978ad4d5d672075]
aws_route_table.hpc_public_route_table: Refreshing state... [id=rtb-068b4facca57e48b9]
aws_route_table_association.hpc_route_table_public_subnet-1: Refreshing state... [id=rtbassoc-0c36eabc085cb8beb]
aws_network_interface.hpc_interface["node2"]: Refreshing state... [id=eni-0db98742b2257297d]
aws_network_interface.hpc_interface["master"]: Refreshing state... [id=eni-0b7663dd7bf17a975]       
aws_network_interface.hpc_interface["node1"]: Refreshing state... [id=eni-02fb90151af44d25e]
aws_instance.hpc_aws_instance["master"]: Refreshing state... [id=i-0f968c48404fbcff4]
aws_instance.hpc_aws_instance["node2"]: Refreshing state... [id=i-0dab989e56873c6f0]
aws_instance.hpc_aws_instance["node1"]: Refreshing state... [id=i-0c22b1f93fdcc7736]

Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_instance.hpc_aws_instance["master"] will be destroyed
  - resource "aws_instance" "hpc_aws_instance" {
      - ami                                  = "ami-0d5bf08bc8017c83b" -> null
      - arn                                  = "arn:aws:ec2:us-east-2:180775276220:instance/i-0f968c48404fbcff4" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "us-east-2c" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 1 -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-0f968c48404fbcff4" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t2.micro" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - key_name                             = "aws_hpc_keypair" -> null
      - monitoring                           = false -> null
      - primary_network_interface_id         = "eni-0b7663dd7bf17a975" -> null
      - private_dns                          = "ip-10-0-1-100.us-east-2.compute.internal" -> null   
      - private_ip                           = "10.0.1.100" -> null
      - public_dns                           = "ec2-18-188-162-188.us-east-2.compute.amazonaws.com" 
-> null
      - public_ip                            = "18.188.162.188" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-070ebdf9f806b83f5" -> null
      - tags                                 = {
          - "Environment" = "Sandbox"
          - "Managed"     = "IaC"
          - "Name"        = "HPC E2 instance master"
          - "OS"          = "Ubuntu 20.04"
        } -> null
      - tags_all                             = {
          - "Environment" = "Sandbox"
          - "Managed"     = "IaC"
          - "Name"        = "HPC E2 instance master"
          - "OS"          = "Ubuntu 20.04"
        } -> null
      - tenancy                              = "default" -> null
      - user_data_replace_on_change          = false -> null
      - vpc_security_group_ids               = [
          - "sg-04978ad4d5d672075",
        ] -> null

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - credit_specification {
          - cpu_credits = "standard" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_put_response_hop_limit = 1 -> null
          - http_tokens                 = "optional" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - network_interface {
          - delete_on_termination = false -> null
          - device_index          = 0 -> null
          - network_card_index    = 0 -> null
          - network_interface_id  = "eni-0b7663dd7bf17a975" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/sda1" -> null
          - encrypted             = false -> null
          - iops                  = 100 -> null
          - tags                  = {} -> null
          - throughput            = 0 -> null
          - volume_id             = "vol-0ad083cd6445669c0" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp2" -> null
        }
    }

  # aws_instance.hpc_aws_instance["node1"] will be destroyed
  - resource "aws_instance" "hpc_aws_instance" {
      - ami                                  = "ami-0d5bf08bc8017c83b" -> null
      - arn                                  = "arn:aws:ec2:us-east-2:180775276220:instance/i-0c22b1f93fdcc7736" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "us-east-2c" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 1 -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-0c22b1f93fdcc7736" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t2.micro" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - key_name                             = "aws_hpc_keypair" -> null
      - monitoring                           = false -> null
      - primary_network_interface_id         = "eni-02fb90151af44d25e" -> null
      - private_dns                          = "ip-10-0-1-101.us-east-2.compute.internal" -> null   
      - private_ip                           = "10.0.1.101" -> null
      - public_dns                           = "ec2-3-19-143-186.us-east-2.compute.amazonaws.com" -> null
      - public_ip                            = "3.19.143.186" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-070ebdf9f806b83f5" -> null
      - tags                                 = {
          - "Environment" = "Sandbox"
          - "Managed"     = "IaC"
          - "Name"        = "HPC E2 instance node1"
          - "OS"          = "Ubuntu 20.04"
        } -> null
      - tags_all                             = {
          - "Environment" = "Sandbox"
          - "Managed"     = "IaC"
          - "Name"        = "HPC E2 instance node1"
          - "OS"          = "Ubuntu 20.04"
        } -> null
      - tenancy                              = "default" -> null
      - user_data_replace_on_change          = false -> null
      - vpc_security_group_ids               = [
          - "sg-04978ad4d5d672075",
        ] -> null

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - credit_specification {
          - cpu_credits = "standard" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_put_response_hop_limit = 1 -> null
          - http_tokens                 = "optional" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - network_interface {
          - delete_on_termination = false -> null
          - device_index          = 0 -> null
          - network_card_index    = 0 -> null
          - network_interface_id  = "eni-02fb90151af44d25e" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/sda1" -> null
          - encrypted             = false -> null
          - iops                  = 100 -> null
          - tags                  = {} -> null
          - throughput            = 0 -> null
          - volume_id             = "vol-09601028e9faa2ca1" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp2" -> null
        }
    }

  # aws_instance.hpc_aws_instance["node2"] will be destroyed
  - resource "aws_instance" "hpc_aws_instance" {
      - ami                                  = "ami-0d5bf08bc8017c83b" -> null
      - arn                                  = "arn:aws:ec2:us-east-2:180775276220:instance/i-0dab989e56873c6f0" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "us-east-2c" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 1 -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-0dab989e56873c6f0" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t2.micro" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - key_name                             = "aws_hpc_keypair" -> null
      - monitoring                           = false -> null
      - primary_network_interface_id         = "eni-0db98742b2257297d" -> null
      - private_dns                          = "ip-10-0-1-102.us-east-2.compute.internal" -> null   
      - private_ip                           = "10.0.1.102" -> null
      - public_dns                           = "ec2-3-139-62-104.us-east-2.compute.amazonaws.com" -> null
      - public_ip                            = "3.139.62.104" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-070ebdf9f806b83f5" -> null
      - tags                                 = {
          - "Environment" = "Sandbox"
          - "Managed"     = "IaC"
          - "Name"        = "HPC E2 instance node2"
          - "OS"          = "Ubuntu 20.04"
        } -> null
      - tags_all                             = {
          - "Environment" = "Sandbox"
          - "Managed"     = "IaC"
          - "Name"        = "HPC E2 instance node2"
          - "OS"          = "Ubuntu 20.04"
        } -> null
      - tenancy                              = "default" -> null
      - user_data_replace_on_change          = false -> null
      - vpc_security_group_ids               = [
          - "sg-04978ad4d5d672075",
        ] -> null

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - credit_specification {
          - cpu_credits = "standard" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_put_response_hop_limit = 1 -> null
          - http_tokens                 = "optional" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - network_interface {
          - delete_on_termination = false -> null
          - device_index          = 0 -> null
          - network_card_index    = 0 -> null
          - network_interface_id  = "eni-0db98742b2257297d" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/sda1" -> null
          - encrypted             = false -> null
          - iops                  = 100 -> null
          - tags                  = {} -> null
          - throughput            = 0 -> null
          - volume_id             = "vol-035401a7d9aabc195" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp2" -> null
        }
    }

  # aws_internet_gateway.hpc_igw will be destroyed
  - resource "aws_internet_gateway" "hpc_igw" {
      - arn      = "arn:aws:ec2:us-east-2:180775276220:internet-gateway/igw-031d12da2d12f84cb" -> null
      - id       = "igw-031d12da2d12f84cb" -> null
      - owner_id = "180775276220" -> null
      - tags     = {
          - "Name" = "hpc-igw"
        } -> null
      - tags_all = {
          - "Name" = "hpc-igw"
        } -> null
      - vpc_id   = "vpc-035315ec2007e9693" -> null
    }

  # aws_network_interface.hpc_interface["master"] will be destroyed
  - resource "aws_network_interface" "hpc_interface" {
      - arn                       = "arn:aws:ec2:us-east-2:180775276220:network-interface/eni-0b7663dd7bf17a975" -> null
      - id                        = "eni-0b7663dd7bf17a975" -> null
      - interface_type            = "interface" -> null
      - ipv4_prefix_count         = 0 -> null
      - ipv4_prefixes             = [] -> null
      - ipv6_address_count        = 0 -> null
      - ipv6_address_list         = [] -> null
      - ipv6_address_list_enabled = false -> null
      - ipv6_addresses            = [] -> null
      - ipv6_prefix_count         = 0 -> null
      - ipv6_prefixes             = [] -> null
      - mac_address               = "0a:ab:a7:02:dd:dc" -> null
      - owner_id                  = "180775276220" -> null
      - private_dns_name          = "ip-10-0-1-100.us-east-2.compute.internal" -> null
      - private_ip                = "10.0.1.100" -> null
      - private_ip_list           = [
          - "10.0.1.100",
        ] -> null
      - private_ip_list_enabled   = false -> null
      - private_ips               = [
          - "10.0.1.100",
        ] -> null
      - private_ips_count         = 0 -> null
      - security_groups           = [
          - "sg-04978ad4d5d672075",
        ] -> null
      - source_dest_check         = true -> null
      - subnet_id                 = "subnet-070ebdf9f806b83f5" -> null
      - tags                      = {} -> null
      - tags_all                  = {} -> null

      - attachment {
          - attachment_id = "eni-attach-032cfdce5fb6201c1" -> null
          - device_index  = 0 -> null
          - instance      = "i-0f968c48404fbcff4" -> null
        }
    }

  # aws_network_interface.hpc_interface["node1"] will be destroyed
  - resource "aws_network_interface" "hpc_interface" {
      - arn                       = "arn:aws:ec2:us-east-2:180775276220:network-interface/eni-02fb90151af44d25e" -> null
      - id                        = "eni-02fb90151af44d25e" -> null
      - interface_type            = "interface" -> null
      - ipv4_prefix_count         = 0 -> null
      - ipv4_prefixes             = [] -> null
      - ipv6_address_count        = 0 -> null
      - ipv6_address_list         = [] -> null
      - ipv6_address_list_enabled = false -> null
      - ipv6_addresses            = [] -> null
      - ipv6_prefix_count         = 0 -> null
      - ipv6_prefixes             = [] -> null
      - mac_address               = "0a:9a:88:56:84:be" -> null
      - owner_id                  = "180775276220" -> null
      - private_dns_name          = "ip-10-0-1-101.us-east-2.compute.internal" -> null
      - private_ip                = "10.0.1.101" -> null
      - private_ip_list           = [
          - "10.0.1.101",
        ] -> null
      - private_ip_list_enabled   = false -> null
      - private_ips               = [
          - "10.0.1.101",
        ] -> null
      - private_ips_count         = 0 -> null
      - security_groups           = [
          - "sg-04978ad4d5d672075",
        ] -> null
      - source_dest_check         = true -> null
      - subnet_id                 = "subnet-070ebdf9f806b83f5" -> null
      - tags                      = {} -> null
      - tags_all                  = {} -> null

      - attachment {
          - attachment_id = "eni-attach-07756a7a76da4ab7e" -> null
          - device_index  = 0 -> null
          - instance      = "i-0c22b1f93fdcc7736" -> null
        }
    }

  # aws_network_interface.hpc_interface["node2"] will be destroyed
  - resource "aws_network_interface" "hpc_interface" {
      - arn                       = "arn:aws:ec2:us-east-2:180775276220:network-interface/eni-0db98742b2257297d" -> null
      - id                        = "eni-0db98742b2257297d" -> null
      - interface_type            = "interface" -> null
      - ipv4_prefix_count         = 0 -> null
      - ipv4_prefixes             = [] -> null
      - ipv6_address_count        = 0 -> null
      - ipv6_address_list         = [] -> null
      - ipv6_address_list_enabled = false -> null
      - ipv6_addresses            = [] -> null
      - ipv6_prefix_count         = 0 -> null
      - ipv6_prefixes             = [] -> null
      - mac_address               = "0a:e0:93:52:65:28" -> null
      - owner_id                  = "180775276220" -> null
      - private_dns_name          = "ip-10-0-1-102.us-east-2.compute.internal" -> null
      - private_ip                = "10.0.1.102" -> null
      - private_ip_list           = [
          - "10.0.1.102",
        ] -> null
      - private_ip_list_enabled   = false -> null
      - private_ips               = [
          - "10.0.1.102",
        ] -> null
      - private_ips_count         = 0 -> null
      - security_groups           = [
          - "sg-04978ad4d5d672075",
        ] -> null
      - source_dest_check         = true -> null
      - subnet_id                 = "subnet-070ebdf9f806b83f5" -> null
      - tags                      = {} -> null
      - tags_all                  = {} -> null

      - attachment {
          - attachment_id = "eni-attach-073019dcd1673217a" -> null
          - device_index  = 0 -> null
          - instance      = "i-0dab989e56873c6f0" -> null
        }
    }

  # aws_route_table.hpc_public_route_table will be destroyed
  - resource "aws_route_table" "hpc_public_route_table" {
      - arn              = "arn:aws:ec2:us-east-2:180775276220:route-table/rtb-068b4facca57e48b9" -> null
      - id               = "rtb-068b4facca57e48b9" -> null
      - owner_id         = "180775276220" -> null
      - propagating_vgws = [] -> null
      - route            = [
          - {
              - carrier_gateway_id         = ""
              - cidr_block                 = "0.0.0.0/0"
              - core_network_arn           = ""
              - destination_prefix_list_id = ""
              - egress_only_gateway_id     = ""
              - gateway_id                 = "igw-031d12da2d12f84cb"
              - instance_id                = ""
              - ipv6_cidr_block            = ""
              - local_gateway_id           = ""
              - nat_gateway_id             = ""
              - network_interface_id       = ""
              - transit_gateway_id         = ""
              - vpc_endpoint_id            = ""
              - vpc_peering_connection_id  = ""
            },
        ] -> null
      - tags             = {
          - "Name" = "hpc-public-route-table"
        } -> null
      - tags_all         = {
          - "Name" = "hpc-public-route-table"
        } -> null
      - vpc_id           = "vpc-035315ec2007e9693" -> null
    }

  # aws_route_table_association.hpc_route_table_public_subnet-1 will be destroyed
  - resource "aws_route_table_association" "hpc_route_table_public_subnet-1" {
      - id             = "rtbassoc-0c36eabc085cb8beb" -> null
      - route_table_id = "rtb-068b4facca57e48b9" -> null
      - subnet_id      = "subnet-070ebdf9f806b83f5" -> null
    }

  # aws_security_group.allow_ssh_sg will be destroyed
  - resource "aws_security_group" "allow_ssh_sg" {
      - arn                    = "arn:aws:ec2:us-east-2:180775276220:security-group/sg-04978ad4d5d672075" -> null
      - description            = "allow ssh inbond traffic" -> null
      - egress                 = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = ""
              - from_port        = 0
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "-1"
              - security_groups  = []
              - self             = false
              - to_port          = 0
            },
        ] -> null
      - id                     = "sg-04978ad4d5d672075" -> null
      - ingress                = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = ""
              - from_port        = 22
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 22
            },
        ] -> null
      - name                   = "terraform-20221028172020113600000001" -> null
      - name_prefix            = "terraform-" -> null
      - owner_id               = "180775276220" -> null
      - revoke_rules_on_delete = false -> null
      - tags                   = {
          - "name" = "allowed_ssh"
        } -> null
      - tags_all               = {
          - "name" = "allowed_ssh"
        } -> null
      - vpc_id                 = "vpc-035315ec2007e9693" -> null
    }

  # aws_subnet.hpc_subnet will be destroyed
  - resource "aws_subnet" "hpc_subnet" {
      - arn                                            = "arn:aws:ec2:us-east-2:180775276220:subnet/subnet-070ebdf9f806b83f5" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "us-east-2c" -> null
      - availability_zone_id                           = "use2-az3" -> null
      - cidr_block                                     = "10.0.1.0/24" -> null
      - enable_dns64                                   = false -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-070ebdf9f806b83f5" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = true -> null
      - owner_id                                       = "180775276220" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - tags                                           = {
          - "Name" = "hpc_subnet"
        } -> null
      - tags_all                                       = {
          - "Name" = "hpc_subnet"
        } -> null
      - vpc_id                                         = "vpc-035315ec2007e9693" -> null
    }

  # aws_vpc.hpc_vpc will be destroyed
  - resource "aws_vpc" "hpc_vpc" {
      - arn                                  = "arn:aws:ec2:us-east-2:180775276220:vpc/vpc-035315ec2007e9693" -> null
      - assign_generated_ipv6_cidr_block     = false -> null
      - cidr_block                           = "10.0.0.0/16" -> null
      - default_network_acl_id               = "acl-0709b0df24cfe2c3c" -> null
      - default_route_table_id               = "rtb-06c04f8283b053d85" -> null
      - default_security_group_id            = "sg-0f7aaa276c6d846ab" -> null
      - dhcp_options_id                      = "dopt-09985c8746d3b7caa" -> null
      - enable_classiclink                   = false -> null
      - enable_classiclink_dns_support       = false -> null
      - enable_dns_hostnames                 = true -> null
      - enable_dns_support                   = true -> null
      - enable_network_address_usage_metrics = false -> null
      - id                                   = "vpc-035315ec2007e9693" -> null
      - instance_tenancy                     = "default" -> null
      - ipv6_netmask_length                  = 0 -> null
      - main_route_table_id                  = "rtb-06c04f8283b053d85" -> null
      - owner_id                             = "180775276220" -> null
      - tags                                 = {
          - "Name" = "hpc_vpc"
        } -> null
      - tags_all                             = {
          - "Name" = "hpc_vpc"
        } -> null
    }

Plan: 0 to add, 0 to change, 12 to destroy.

Changes to Outputs:
  - aws_hpc_instance         = {
      - master = "18.188.162.188"
      - node1  = "3.19.143.186"
      - node2  = "3.139.62.104"
    } -> null
  - datasource_host_2_ip_out = [
      - "master",
      - "node1",
      - "node2",
    ] -> null
  - local_host_2_ip_out      = [
      - "master",
      - "node1",
      - "node2",
    ] -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_route_table_association.hpc_route_table_public_subnet-1: Destroying... [id=rtbassoc-0c36eabc085cb8beb]
aws_instance.hpc_aws_instance["node2"]: Destroying... [id=i-0dab989e56873c6f0]
aws_instance.hpc_aws_instance["node1"]: Destroying... [id=i-0c22b1f93fdcc7736]
aws_instance.hpc_aws_instance["master"]: Destroying... [id=i-0f968c48404fbcff4]
aws_route_table_association.hpc_route_table_public_subnet-1: Destruction complete after 0s
aws_route_table.hpc_public_route_table: Destroying... [id=rtb-068b4facca57e48b9]
aws_route_table.hpc_public_route_table: Destruction complete after 0s
aws_internet_gateway.hpc_igw: Destroying... [id=igw-031d12da2d12f84cb]
aws_instance.hpc_aws_instance["node2"]: Still destroying... [id=i-0dab989e56873c6f0, 10s elapsed]
aws_instance.hpc_aws_instance["node1"]: Still destroying... [id=i-0c22b1f93fdcc7736, 10s elapsed]   
aws_instance.hpc_aws_instance["master"]: Still destroying... [id=i-0f968c48404fbcff4, 10s elapsed]
aws_internet_gateway.hpc_igw: Still destroying... [id=igw-031d12da2d12f84cb, 10s elapsed]
aws_instance.hpc_aws_instance["node2"]: Still destroying... [id=i-0dab989e56873c6f0, 20s elapsed]
aws_instance.hpc_aws_instance["node1"]: Still destroying... [id=i-0c22b1f93fdcc7736, 20s elapsed]   
aws_instance.hpc_aws_instance["master"]: Still destroying... [id=i-0f968c48404fbcff4, 20s elapsed]
aws_internet_gateway.hpc_igw: Still destroying... [id=igw-031d12da2d12f84cb, 20s elapsed]
aws_internet_gateway.hpc_igw: Destruction complete after 28s
aws_instance.hpc_aws_instance["node2"]: Still destroying... [id=i-0dab989e56873c6f0, 30s elapsed]
aws_instance.hpc_aws_instance["node1"]: Still destroying... [id=i-0c22b1f93fdcc7736, 30s elapsed]   
aws_instance.hpc_aws_instance["master"]: Still destroying... [id=i-0f968c48404fbcff4, 30s elapsed]
aws_instance.hpc_aws_instance["node1"]: Destruction complete after 30s
aws_instance.hpc_aws_instance["node2"]: Destruction complete after 30s
aws_instance.hpc_aws_instance["master"]: Destruction complete after 30s
aws_network_interface.hpc_interface["master"]: Destroying... [id=eni-0b7663dd7bf17a975]
aws_network_interface.hpc_interface["node1"]: Destroying... [id=eni-02fb90151af44d25e]
aws_network_interface.hpc_interface["node2"]: Destroying... [id=eni-0db98742b2257297d]
aws_network_interface.hpc_interface["node1"]: Destruction complete after 1s
aws_network_interface.hpc_interface["master"]: Destruction complete after 1s
aws_network_interface.hpc_interface["node2"]: Destruction complete after 1s
aws_subnet.hpc_subnet: Destroying... [id=subnet-070ebdf9f806b83f5]
aws_security_group.allow_ssh_sg: Destroying... [id=sg-04978ad4d5d672075]
aws_subnet.hpc_subnet: Destruction complete after 0s
aws_security_group.allow_ssh_sg: Destruction complete after 1s
aws_vpc.hpc_vpc: Destroying... [id=vpc-035315ec2007e9693]
aws_vpc.hpc_vpc: Destruction complete after 0s

Destroy complete! Resources: 12 destroyed.
```


### referene:
[VPC with public and private subnets (NAT)](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.html)
[Attach IAM role to AWS EC2 instance using Terraform](https://skundunotes.com/2021/11/16/attach-iam-role-to-aws-ec2-instance-using-terraform/)
[Terraform and Ansible](https://www.bitslovers.com/terraform-and-ansible/)
