output "dev-instance" {
    value = aws_instance.dev-server
}

output "jenkins_node_cidr_for_sg" {
    value = "${data.aws_instance.jenkins_node.public_ip}/32"
    depends_on = [
      aws_instance.dev-server
    ]
}