data "tencentcloud_images" "image_centos76x64" {
  image_type       = ["PUBLIC_IMAGE"]
  image_name_regex = "^CentOS\\s+7\\.6\\s+64\\w*"
}

# 独立资源 VPC
resource "tencentcloud_vpc" "vpc_01" {
  name       = "terraform_test"
  cidr_block = "10.0.0.0/16"

  tags = {
    "name" = "terraform_test"
  }
}

resource "tencentcloud_subnet" "subnet_01" {
  depends_on        = [tencentcloud_vpc.vpc_01]
  for_each          = var.subnets
  cidr_block        = each.value.cidr_block
  name              = each.value.name
  availability_zone = each.value.availability_zone
  vpc_id            = tencentcloud_vpc.vpc_01.id

  tags = {
    "name" = "terraform_test"
  }
}

# 独立资源 EIP
resource "tencentcloud_eip" "eip_01" {
  name                       = "terraform_test"
  type                       = "EIP"
  internet_charge_type       = "TRAFFIC_POSTPAID_BY_HOUR"
  internet_max_bandwidth_out = 10

  tags = {
    "name" = "terraform_test"
  }
}

resource "tencentcloud_nat_gateway" "nat_gateway_01" {
  depends_on       = [tencentcloud_eip.eip_01]
  name             = "terraform_test"
  vpc_id           = tencentcloud_vpc.vpc_01.id
  assigned_eip_set = [tencentcloud_eip.eip_01.public_ip]
  bandwidth        = 10
  max_concurrent   = 1000000

  tags = {
    "name" = "terraform_test"
  }
}

# 独立资源 Security Group
resource "tencentcloud_security_group" "sg_01" {
  name = "terraform_test"

  tags = {
    "name" = "terraform_test"
  }
}

resource "tencentcloud_security_group_lite_rule" "sg_01_rules" {
  security_group_id = tencentcloud_security_group.sg_01.id

  ingress = [
    "ACCEPT#0.0.0.0/0#ALL#ALL"
  ]

  egress = [
    "ACCEPT#0.0.0.0/0#ALL#ALL"
  ]
}

resource "tencentcloud_kubernetes_cluster" "tke_cluster_01" {
  depends_on              = [tencentcloud_vpc.vpc_01]
  vpc_id                  = tencentcloud_vpc.vpc_01.id
  cluster_cidr            = var.default_tke_cluster_cidr
  cluster_max_pod_num     = 64
  cluster_name            = "terraform_test"
  cluster_desc            = "terraform_test"
  cluster_max_service_num = 1024
  cluster_deploy_type     = "MANAGED_CLUSTER"
  cluster_ipvs            = false
  cluster_level           = "L20"
  cluster_os              = "tlinux3.1x86_64"
  cluster_version         = "1.22.5"
  container_runtime       = "docker"
  network_type            = "GR"

  labels = {
    "name" = "terraform_test"
  }

  tags = {
    "name" = "terraform_test"
  }
}

//this is one example of managing node using node pool
resource "tencentcloud_kubernetes_node_pool" "tke_cluster_01_node_pool" {
  depends_on               = [tencentcloud_vpc.vpc_01, tencentcloud_subnet.subnet_01, tencentcloud_security_group.sg_01, tencentcloud_kubernetes_cluster.tke_cluster_01]
  name                     = "terraform_test"
  cluster_id               = tencentcloud_kubernetes_cluster.tke_cluster_01.id
  max_size                 = 10
  min_size                 = 7
  vpc_id                   = tencentcloud_vpc.vpc_01.id
  subnet_ids               = tolist([for subnet in tencentcloud_subnet.subnet_01 : subnet.id])
  retry_policy             = "INCREMENTAL_INTERVALS"
  desired_capacity         = 7
  enable_auto_scale        = true
  multi_zone_subnet_policy = "EQUALITY"
  delete_keep_instance     = false

  auto_scaling_config {
    instance_type      = var.default_instance_type
    system_disk_type   = "CLOUD_SSD"
    system_disk_size   = 50
    security_group_ids = [tencentcloud_security_group.sg_01.id]

    data_disk {
      disk_type            = "CLOUD_SSD"
      disk_size            = 100
      delete_with_instance = true
    }

    internet_charge_type = "TRAFFIC_POSTPAID_BY_HOUR"
    public_ip_assigned   = false
    password             = "eQhUH{S}D6"
    host_name            = "terraform-test-tke"
    host_name_style      = "ORIGINAL"
  }

  labels = {
    "name" = "terraform_test"
  }

  node_config {
    extra_args = [
      "root-dir=/var/lib/kubelet"
    ]
  }
}
