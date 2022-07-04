resource "aws_security_group" "env-servers-sg" {
   name = "env-servers-sg"
   vpc_id = var.vpc_id

   ingress {
     cidr_blocks = [var.my_ip]
     from_port = 22
     protocol = "tcp"
     to_port = 22
   }
   ingress {
     cidr_blocks = [var.vpccidrblock]
     from_port = 22
     protocol = "tcp"
     to_port = 22
   }

   ingress {
   cidr_blocks = ["0.0.0.0/0"]
   from_port = 8080
   protocol = "tcp"
   to_port = 8080
   }

   egress {
   cidr_blocks = ["0.0.0.0/0"]
   from_port = 0
   protocol = "-1"
   to_port = 0
   prefix_list_ids = []
   }
   tags = {
      Name: "${var.env_prefix}-sg"
   }
}

data "aws_ami" "latest-amazon-linux-image" {
   most_recent = true
   owners = ["amazon"]
   filter {
      name = "name"
      values = ["amzn2-ami-kernel-*-x86_64-gp2"]
   }
   filter {
      name = "virtualization-type"
      values = ["hvm"]
   }
}

resource "aws_instance" "dev-server" {
   ami = data.aws_ami.latest-amazon-linux-image.id
   instance_type = var.instance_type
   subnet_id = var.subnet_id
   vpc_security_group_ids = [aws_security_group.env-servers-sg.id]
   availability_zone = var.avail_zone
   associate_public_ip_address = true
   key_name = "server-key-pair"
   #assign role to be able to create slave nodes
#    iam_instance_profile = "jenkins_aws_role"
   user_data = <<-EOF
      #!/bin/bash
         sudo yum update -y && sudo yum install -y docker
         sudo systemctl start docker
         sudo usermod -aG docker ec2-user
   EOF
   # user_data = file("initscript_dev_env.sh")
   tags = {
      Name: "Dev-${var.instance_name}-${var.env_prefix}-server"}
} 
