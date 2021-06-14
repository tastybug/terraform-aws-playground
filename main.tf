provider "aws" {
  region = "us-east-1"
}

# module "one" {
#   source = "./modules/module_one"
# }

# module "two" {
#   source = "./modules/module_two"
# }

module "ec2" {
  source = "./modules/ec2"

  for_each      = toset(["wonky", "hairy"])
  instance-name = each.key
}

output "assigned_ips" {
  value = toset([
    for ec2 in module.ec2 : ec2.public_ip
  ])
  description = "stuff"
}
