output "Jenkins_public_ip" {
   value = module.Jenkins_master.instance.public_ip
}

output "Jenkins_URL" {
  value = "http://${module.Jenkins_master.instance.public_ip}:8080"
}