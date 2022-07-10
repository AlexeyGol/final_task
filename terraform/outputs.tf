output "Jenkins_public_ip" {
   value = module.Jenkins_master.instance.public_ip
}

output "Dev_server_public_ip" {
   value = module.dev_server.dev-instance.public_ip
}

output "add_Jenkins_URL_to_actual_jenkins_location" {
  value = "http://${module.Jenkins_master.instance.public_ip}:8080/configure"
}

output "add_webhook_to_github" {
  value = "https://github.com/AlexeyGol/final_task/settings/hooks http://${module.Jenkins_master.instance.public_ip}:8080/github-webhook"
}

output "Configure_security_group_for_jenkins_node_plugin" {
  value = "Add it to Manage Nodes > Configure clouds > rh 8 > under initscritpt > advanced ${module.myapp-initstaff.subnet.id}"
}

output "add_Jenkins_node_ip_to_variables" {
   value = "to variables"
}
