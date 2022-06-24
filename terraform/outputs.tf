output "Jenkins_public_ip" {
   value = module.Jenkins_master.instance.public_ip
}