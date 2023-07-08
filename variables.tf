# 定义子网变量
variable "subnets" {
  type = map(object({
    cidr_block        = string
    name              = string
    availability_zone = string
  }))

  default = {
    subnet2 = {
      cidr_block        = "10.0.2.0/24"
      name              = "subnet_az2"
      availability_zone = "ap-beijing-2"
    },
    subnet3 = {
      cidr_block        = "10.0.3.0/24"
      name              = "subnet_az3"
      availability_zone = "ap-beijing-3"
    },
    subnet4 = {
      cidr_block        = "10.0.4.0/24"
      name              = "subnet_az4"
      availability_zone = "ap-beijing-4"
    },
    subnet5 = {
      cidr_block        = "10.0.5.0/24"
      name              = "subnet_az5"
      availability_zone = "ap-beijing-5"
    },
    subnet6 = {
      cidr_block        = "10.0.6.0/24"
      name              = "subnet_az6"
      availability_zone = "ap-beijing-6"
    },
    subnet7 = {
      cidr_block        = "10.0.7.0/24"
      name              = "subnet_az7"
      availability_zone = "ap-beijing-7"
    }
  }
}

# 定义 TKE 集群容器网络默认 CIDR
variable "default_tke_cluster_cidr" {
  default = "172.16.0.0/16"
}

# 定义 TKE 集群默认机型
variable "default_instance_type" {
  default = "S3.LARGE16"
}
