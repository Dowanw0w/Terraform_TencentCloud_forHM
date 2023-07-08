terraform {
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = "1.81.11"
    }
  }
}

# AK & SK
provider "tencentcloud" {
  region     = "ap-beijing"
  secret_id  = ""
  secret_key = ""
}
