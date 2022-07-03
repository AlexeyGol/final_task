variable my_ip {
    default = "185.220.94.81/32"
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
variable ansible_work_dir {}
variable ssh_key_private {}
