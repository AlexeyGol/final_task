resource "aws_security_group" "myapp-sg" {
   name = "myapp-sg"
   vpc_id = var.vpc_id

   ingress {
     cidr_blocks = [var.my_ip]
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



resource "aws_instance" "myapp-server" {
   ami = data.aws_ami.latest-amazon-linux-image.id
   instance_type = var.instance_type
   subnet_id = var.subnet_id
   vpc_security_group_ids = [aws_security_group.myapp-sg.id]
   availability_zone = var.avail_zone
   associate_public_ip_address = true
   key_name = "server-key-pair"
   tags = {
      Name: "${var.instance_name}-${var.env_prefix}-server"}
   # user_data = file("${path.module}/entry-script.sh")
} 

resource "null_resource" "configure_instanse" {
   triggers = {
      trigger = aws_instance.myapp-server.public_ip
   }
   provisioner "local-exec" {
      working_dir = var.ansible_work_dir
      command = "ansible-playbook --inventory ${aws_instance.myapp-server.public_ip}, --private-key ${var.ssh_key_private} --user ec2-user ${var.playbook_file}"
   }  
}