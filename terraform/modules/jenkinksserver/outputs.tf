output "instance" {
    value = aws_instance.jenkins-server
}
output "jenkins_ip" {
    value = aws_instance.jenkins-server.public_ip
}

