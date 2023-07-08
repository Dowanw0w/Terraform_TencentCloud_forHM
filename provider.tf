terraform {
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = "1.81.11"
    }
  }
}

provider "tencentcloud" {
  region     = "ap-beijing"
  secret_id  = ""
  secret_key = ""
}
