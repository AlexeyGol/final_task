variable Jenkins_ip {
    default = module.Jenkins_master.instance.public_ip
}
variable vpc_id {}
variable my_ip {}
variable env_prefix {}
variable instance_type {}
variable subnet_id {}
variable avail_zone {}
variable instance_name {}

