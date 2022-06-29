output "Jenkins_public_ip" {
   value = module.Jenkins_master.instance.public_ip
}

output "add_Jenkins_URL_to_actual_jenkins_location" {
  value = "http://${module.Jenkins_master.instance.public_ip}:8080/configure"
}

output "add_webhook_to_github" {
  value = "https://github.com/AlexeyGol/final_task/settings/hooks http://${module.Jenkins_master.instance.public_ip}:8080/github-webhook"
}