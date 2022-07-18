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

resource "aws_instance" "prod-server" {
   ami = data.aws_ami.latest-amazon-linux-image.id
   instance_type = var.instance_type
   subnet_id = var.subnet_id
   vpc_security_group_ids = [var.secur_group_for_prod]
   availability_zone = var.avail_zone
   associate_public_ip_address = true
   key_name = "server-key-pair"
   # user_data = <<-EOF
   #    #!/bin/bash
   #       sudo yum update -y && sudo yum install -y docker
   #       sudo usermod -aG docker ec2-user
   #       sudo service docker start
   #       sudo chmod 666 /var/run/docker.sock
   #       sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
   #       sudo chmod +x /usr/local/bin/docker-compose
   #       sudo mkdir /db
   #       sudo mount /dev/xvdh /db
   # EOF
   # user_data = file("initscript_dev_env.sh")
   tags = {
      Name: "Prod-${var.instance_name}-${var.env_prefix}-server"}
} 

resource "aws_volume_attachment" "prod_db_attatch" {
  device_name = "/dev/xvdh"
  volume_id   = "vol-03a11c24fed931879"
  instance_id = aws_instance.prod-server.id
  skip_destroy = true
}


resource "null_resource" "configure_instanse" {
   triggers = {
      trigger = aws_instance.prod-server.public_ip
   }
   provisioner "local-exec" {
      working_dir = var.ansible_work_dir
      command = "ansible-playbook --inventory ${aws_instance.prod-server.public_ip}, --private-key ${var.ssh_key_private} --user ec2-user ${var.playbook_file}"
   }  
}
