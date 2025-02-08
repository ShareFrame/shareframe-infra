variable "ami" {}
variable "instance_type" { default = "t2.micro" }
variable "subnet_id" {}
variable "security_group" {}
variable "iam_instance_profile" { default = "AmazonSSMRoleForInstancesQuickSetup" }
variable "ebs_volume_id" {}
variable "eip_allocation_id" {}
variable "instance_name" { default = "shareframe_pds" }
variable "volume_size" { default = 30 }
