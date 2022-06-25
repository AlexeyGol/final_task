terraform {
  backend "s3" {
    bucket = "tf-states-final-task"
    key    = "devops/finaltask.tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {
   region = "eu-west-2"
}


resource "aws_vpc" "myapp-vpc" {
   cidr_block = var.vpc_cidr_block
   enable_dns_hostnames = true #to show public in dynamic inventory in Ansible
   tags = {
      Name: "${var.env_prefix}-vpc"
   }
}

module "myapp-initstaff" {
   source = "./modules/initstaff"
   subnet_cidr_block = var.subnet_cidr_block
   avail_zone = var.avail_zone
   env_prefix = var.env_prefix 
   vpc_id = aws_vpc.myapp-vpc.id
   vpc_cidr_block = var.vpc_cidr_block
}


module "Jenkins_master" {
   source = "./modules/webserver"
   vpc_id = aws_vpc.myapp-vpc.id
   my_ip = var.my_ip
   env_prefix = var.env_prefix
   instance_type = var.instance_type
   avail_zone = var.avail_zone
   subnet_id = module.myapp-initstaff.subnet.id
   instance_name = "Jenkins"
   
   ansible_work_dir = var.ansible_work_dir
   playbook_file = "deploy_docker-newuser.yaml"
   ssh_key_private = var.ssh_key_private
}