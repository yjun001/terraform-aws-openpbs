# AWS HPC EC2 Instance OpenPBS cluster - created by **terraform**

Create three HPC nodes (OpenPBS) cluster by using aws EC2 instances and [terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs), base on this [hosts file](https://github.com/yjun-001/terraform-aws-openpbs/blob/eb9eb761229cade3f88a9ec3ab9bee57e85c3eed/ansible/inventory/hosts.ini)
https://github.com/yjun-001/terraform-aws-openpbs/blob/eb9eb761229cade3f88a9ec3ab9bee57e85c3eed/ansible/inventory/hosts.ini#L1-L14


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
![Alt text](https://github.com/yjun-001/terraform-aws-openpbs/blob/eb9eb761229cade3f88a9ec3ab9bee57e85c3eed/image/graphviz.svg)

### This repository will do 
- create an AWS VPC with cidr_block = **"10.0.0.0/16"**
- create an AWS Public subnet with cidr_block = **10.0.0.0/24"** # 254 IP addresses available in this subnet
- create an AWS Internat Gateway(IG) and route table (RT)
- create an AWS Security Group (SG), and allow ssh incoming traffic at port 22
- create a three-nodes of EC2 cluster instances, 
  - assign each instances a static private IP. which defined in hosts file above. this IP address is to use as the primary address of private subnet, instead of the default assigned DHCP address, [DHCP Issues](https://stackoverflow.com/questions/42666396/terraform-correctly-assigning-a-static-private-ip-to-newly-created-instance)
  - setup each hostname as well according to hosts file.
  - update private ssh key in master node instance, so it can ssh other nodes without password
- **Install OpenPBS binary(preload at ansible/openpbs/) on each EC2 instance**
  - **nodes**: install/setup MOM (openpbs-execution_22.05.11-1_amd64.deb)
  - **head**: install/setup server/sched/comm daemons (openpbs-server_22.05.11-1_amd64.deb)
  - run test queue jobs - find_prime.sh (see below in action section)

### Code In Action and its output:
#### **terraform apply:**
```bash
>terraform apply
data.archive_file.ansible_script: Reading...
data.external.datasource_host_2_ip: Reading...
data.external.datasource_host_2_ip: Read complete after 1s [id=-]
data.archive_file.ansible_script: Read complete after 2s [id=22145d4c5741dcc72f82debe19274bae9f5aa277]

Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
....
Apply complete! Resources: 18 added, 0 changed, 0 destroyed.

Outputs:

aws_hpc_instance = {
  "master" = "13.59.94.222"
  "node1" = "3.143.207.19"
  "node2" = "18.117.88.159"
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
>pbsadmin@master:~$ systemctl status pbs
● pbs.service - Portable Batch System
     Loaded: loaded (/opt/pbs/libexec/pbs_init.d; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2022-11-01 20:06:37 UTC; 8min ago
       Docs: man:pbs(8)
    Process: 14216 ExecStart=/opt/pbs/libexec/pbs_init.d start (code=exited, status=0/SUCCESS)      
      Tasks: 9
     Memory: 11.1M
     CGroup: /system.slice/pbs.service
             ├─14262 /opt/pbs/sbin/pbs_comm
             ├─14277 /opt/pbs/sbin/pbs_sched
             ├─14313 /opt/pbs/sbin/pbs_ds_monitor monitor
             └─14367 /opt/pbs/sbin/pbs_server.bin

>pbsadmin@master:~$ cp /home/ubuntu/ansible/openpbs/find_prime.sh .
pbsadmin@master:~$ qsub find_prime.sh 
0.master
>pbsadmin@master:~$ qsub find_prime.sh 
1.master
>pbsadmin@master:~$ qsub find_prime.sh 
2.master
>pbsadmin@master:~$ qstat
Job id            Name             User              Time Use S Queue
----------------  ---------------- ----------------  -------- - -----
0.master          find_prime.sh    pbsadmin          00:00:00 R workq
1.master          find_prime.sh    pbsadmin          00:00:00 R workq
2.master          find_prime.sh    pbsadmin                 0 Q workq
>pbsadmin@master:~$ pbsnodes -a
node1
     Mom = node1
     Port = 15002
     pbs_version = 22.05.11
     ntype = PBS
     state = job-busy
     pcpus = 1
     jobs = 0.master/0
     resources_available.arch = linux
     resources_available.host = node1
     resources_available.mem = 989436kb
     resources_available.ncpus = 1
     resources_available.vnode = node1
     resources_assigned.accelerator_memory = 0kb
     resources_assigned.hbmem = 0kb
     resources_assigned.mem = 0kb
     resources_assigned.naccelerators = 0
     resources_assigned.ncpus = 1
     resources_assigned.vmem = 0kb
     resv_enable = True
     sharing = default_shared
     license = l
     last_state_change_time = Tue Nov  1 20:10:55 2022

node2
     Mom = node2
     Port = 15002
     pbs_version = 22.05.11
     ntype = PBS
     state = job-busy
     pcpus = 1
     jobs = 1.master/0
     resources_available.arch = linux
     resources_available.host = node2
     resources_available.mem = 989436kb
     resources_available.ncpus = 1
     resources_available.vnode = node2
     resources_assigned.accelerator_memory = 0kb
     resources_assigned.hbmem = 0kb
     resources_assigned.mem = 0kb
     resources_assigned.naccelerators = 0
     resources_assigned.ncpus = 1
     resources_assigned.vmem = 0kb
     resv_enable = True
     sharing = default_shared
     license = l
     last_state_change_time = Tue Nov  1 20:10:58 2022
```

#### Terraform destroy

```bash
> terraform destroy
....
aws_route_table_association.hpc_route_table_public_subnet: Destroying... [id=rtbassoc-009e173063f30ed41]
aws_iam_policy_attachment.attach: Destroying... [id=hpc-attach-policy]
aws_instance.hpc_aws_instance["node2"]: Destroying... [id=i-0437d34eebac60427]
aws_subnet.hpc_subnet_private: Destroying... [id=subnet-0a9e30fbdcc52175f]
aws_instance.hpc_aws_instance["node1"]: Destroying... [id=i-016da5d8112739d31]
aws_s3_object.ansible_script: Destroying... [id=terraform/hpc-4b340b794c812eb5dbd0d152e4ae87d0.zip] 
aws_instance.hpc_aws_instance["master"]: Destroying... [id=i-0c1730af610a803d9]
aws_route_table_association.hpc_route_table_public_subnet: Destruction complete after 0s
aws_route_table.hpc_public_route_table: Destroying... [id=rtb-0aab12f87843cb792]
aws_iam_policy_attachment.attach: Destruction complete after 0s
aws_iam_policy.hpc_iam_policy: Destroying... [id=arn:aws:iam::180775276220:policy/hpc-iam-policy]   
aws_s3_object.ansible_script: Destruction complete after 0s
aws_iam_policy.hpc_iam_policy: Destruction complete after 1s
aws_subnet.hpc_subnet_private: Destruction complete after 1s
aws_route_table.hpc_public_route_table: Destruction complete after 1s
aws_internet_gateway.hpc_igw: Destroying... [id=igw-0c08784128dc21a99]
aws_instance.hpc_aws_instance["node2"]: Still destroying... [id=i-0437d34eebac60427, 10s elapsed]
aws_instance.hpc_aws_instance["node1"]: Still destroying... [id=i-016da5d8112739d31, 10s elapsed]   
aws_instance.hpc_aws_instance["master"]: Still destroying... [id=i-0c1730af610a803d9, 10s elapsed]
aws_internet_gateway.hpc_igw: Still destroying... [id=igw-0c08784128dc21a99, 10s elapsed]
aws_instance.hpc_aws_instance["node2"]: Still destroying... [id=i-0437d34eebac60427, 20s elapsed]
aws_instance.hpc_aws_instance["node1"]: Still destroying... [id=i-016da5d8112739d31, 20s elapsed]   
aws_instance.hpc_aws_instance["master"]: Still destroying... [id=i-0c1730af610a803d9, 20s elapsed]
aws_internet_gateway.hpc_igw: Still destroying... [id=igw-0c08784128dc21a99, 20s elapsed]
aws_instance.hpc_aws_instance["node2"]: Still destroying... [id=i-0437d34eebac60427, 30s elapsed]
aws_instance.hpc_aws_instance["node1"]: Still destroying... [id=i-016da5d8112739d31, 30s elapsed]   
aws_instance.hpc_aws_instance["master"]: Still destroying... [id=i-0c1730af610a803d9, 30s elapsed]
aws_instance.hpc_aws_instance["node1"]: Destruction complete after 30s
aws_instance.hpc_aws_instance["node2"]: Destruction complete after 30s
aws_internet_gateway.hpc_igw: Still destroying... [id=igw-0c08784128dc21a99, 30s elapsed]
aws_instance.hpc_aws_instance["master"]: Still destroying... [id=i-0c1730af610a803d9, 40s elapsed]
aws_internet_gateway.hpc_igw: Still destroying... [id=igw-0c08784128dc21a99, 40s elapsed]
aws_instance.hpc_aws_instance["master"]: Still destroying... [id=i-0c1730af610a803d9, 50s elapsed]
aws_internet_gateway.hpc_igw: Still destroying... [id=igw-0c08784128dc21a99, 50s elapsed]
aws_instance.hpc_aws_instance["master"]: Still destroying... [id=i-0c1730af610a803d9, 1m0s elapsed]
aws_internet_gateway.hpc_igw: Still destroying... [id=igw-0c08784128dc21a99, 1m0s elapsed]
aws_instance.hpc_aws_instance["master"]: Still destroying... [id=i-0c1730af610a803d9, 1m10s elapsed]aws_internet_gateway.hpc_igw: Still destroying... [id=igw-0c08784128dc21a99, 1m10s elapsed]
aws_internet_gateway.hpc_igw: Destruction complete after 1m18s
aws_instance.hpc_aws_instance["master"]: Still destroying... [id=i-0c1730af610a803d9, 1m20s elapsed]aws_instance.hpc_aws_instance["master"]: Still destroying... [id=i-0c1730af610a803d9, 1m30s elapsed]aws_instance.hpc_aws_instance["master"]: Destruction complete after 1m31s
aws_iam_instance_profile.hpc_iam_profile: Destroying... [id=hpc-iam-profile]
aws_network_interface.hpc_interface["node2"]: Destroying... [id=eni-01d797c9df30b520b]
aws_network_interface.hpc_interface["node1"]: Destroying... [id=eni-0246221893e21eda2]
aws_network_interface.hpc_interface["master"]: Destroying... [id=eni-0e9755e0d066c3251]
aws_iam_instance_profile.hpc_iam_profile: Destruction complete after 1s
aws_iam_role.hpc_iam_role: Destroying... [id=hpc-iam-profile]
aws_network_interface.hpc_interface["node1"]: Destruction complete after 1s
aws_iam_role.hpc_iam_role: Destruction complete after 0s
aws_network_interface.hpc_interface["master"]: Destruction complete after 1s
aws_network_interface.hpc_interface["node2"]: Destruction complete after 1s
aws_subnet.hpc_subnet_public: Destroying... [id=subnet-0221396bc51caf4d8]
aws_security_group.allow_ssh_sg: Destroying... [id=sg-00b88a0178ddaeb4b]
aws_subnet.hpc_subnet_public: Destruction complete after 1s
aws_security_group.allow_ssh_sg: Destruction complete after 1s
aws_vpc.hpc_vpc: Destroying... [id=vpc-034762d88cd8732c5]
aws_vpc.hpc_vpc: Destruction complete after 0s

Destroy complete! Resources: 18 destroyed.
```


### referene:
- [VPC with public and private subnets (NAT)](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.html)
- [Attach IAM role to AWS EC2 instance using Terraform](https://skundunotes.com/2021/11/16/attach-iam-role-to-aws-ec2-instance-using-terraform/)
- [Terraform and Ansible](https://www.bitslovers.com/terraform-and-ansible/)
