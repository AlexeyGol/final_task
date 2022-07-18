variable my_ip {
    description = "Put here your IP for access"
    default = "37.139.175.248/32"
}
variable jenkins_node_ip {
    description = "Put here Jenkins agent node IP"
    default = "13.40.30.56"
}
variable subnet_cidr_block {
    default = "10.0.10.0/24"
}
variable instance_type {
    default = "t2.micro" 
}
variable env_prefix {
    default = "final_task"
}
variable avail_zone {
    default = "eu-west-2a"
}
variable vpc_cidr_block {
    default = "10.0.0.0/16"
}
variable image_name {
    default = "amzn2-ami-kernel-*-x86_64-gp2"
}
variable ansible_work_dir {
    default = "/mnt/f/!EPAM/DevOps_online_Kharkiv_2022Q1Q2/Devops_fin_task/ansible"
}
variable ssh_key_private {
    default = "/home/alex/.ssh/server-key-pair.pem"
}
