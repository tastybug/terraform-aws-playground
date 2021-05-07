provider "aws" {
  region = "us-east-1"
}

module "one" {
  source = "./module_one"
}

module "two" {
  source = "./module_two"
}
