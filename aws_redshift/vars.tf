variable "region" {
  default = "us-west-1"
}

variable "obj_prefix" {
  default = "redshift-testing-6u2j5t5"
}

variable "awsprofile" {
  default = "personal"
}

provider "aws" {
  profile = var.awsprofile
  region  = var.region
}