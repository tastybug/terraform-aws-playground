
# list of AMIs under https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "another_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "Another ec2 instance."
  }
}

output "public_ip" {
  value       = aws_instance.another_ec2.public_ip
  description = "The public IP assigned to the instance."
}