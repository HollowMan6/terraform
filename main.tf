terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-lunar-23.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

variable "key_name" {
  description = "Key name for the EC2 instance"
  type        = string
  default     = "local"
}

resource "aws_instance" "vm1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "c6a.large"
  key_name      = var.key_name

  cpu_options {
    amd_sev_snp = "enabled"
  }

  tags = {
    Name = "vm1"
  }

  connection {
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/${var.key_name}.pem")
    agent       = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y build-essential git libssl-dev uuid-dev autoconf",
      "git clone https://github.com/AMDESE/sev-guest.git",
      "cd sev-guest",
      "make sev-guest-get-report",
      "make sev-guest-parse-report",
      "sudo ./sev-guest-get-report guest_report.bin -x",
      "sudo mkdir certs",
      "sudo openssl x509 -inform der -in a8074bc2-a25a-483e-aae6-39c045a0b8a1 -out certs/vcek.pem",
      "sudo curl --proto '=https' --tlsv1.2 -sSf https://kdsintf.amd.com/vlek/v1/Milan/cert_chain -o certs/cert_chain.pem",
      "sudo openssl verify --CAfile certs/cert_chain.pem certs/vcek.pem",
      "sudo cp guest_report.bin certs/",
      "cd ..",
      "git clone https://github.com/AMDESE/sev-tool.git",
      "cd sev-tool",
      "autoreconf -vif && ./configure && make",
      "sudo ./src/sevtool --ofolder ../sev-guest/certs --validate_guest_report"
    ]
  }

}
