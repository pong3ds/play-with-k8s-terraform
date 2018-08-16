variable "region" {
  default = "ap-southeast-1"
}

variable "credential" {
  default = "/Users/chaiyapong/.aws/credentials"
}

variable "user" {
  default = "terraform"
}

variable "ubuntu_ami" {
  default = "ami-51a7aa2d"
}

variable "group_name" {
  default = "play-with-k8s"
}

variable "key_name" {
  default = "play-with-k8s"
}

variable "cluster_name" {
  default = "play-with-k8s"
}

variable "security_group_id" {
  default = "sg-0d56c70ff4daa6f15"
}

variable "vpc_id" {
  default = "vpc-886579ec"
}

variable "subnet_id" {
  default = "subnet-a515b8c2"
}


provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${var.credential}"
  profile                 = "${var.user}"
}

module "ec2_cluster" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name           = "${var.cluster_name}"
  instance_count = 4

  ami                    = "${var.ubuntu_ami}"
  instance_type          = "t2.medium"
  key_name               = "${var.key_name}"
  monitoring             = true
  vpc_security_group_ids = ["${var.security_group_id}"]
  subnet_id              = "${var.subnet_id}"

  associate_public_ip_address = true
  ebs_block_device = [{
        device_name = "/dev/sdg"
        volume_size = 50
        volume_type = "gp2"
        delete_on_termination = true
    }]

  tags = {
    GroupName = "${var.group_name}"
  }
}