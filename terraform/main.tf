terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "key_name" {
  type        = string
  description = "Existing AWS key pair name used to access the EC2 instance."
  default     = "envirotrack-key"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the EnviroTrack host."
  default     = "t2.micro"
}

variable "ami_id" {
  type        = string
  description = "AMI used for the EnviroTrack host."
  default     = "ami-0c101f26f147fa7fd"
}

variable "allowed_cidr" {
  type        = string
  description = "CIDR allowed to SSH to the host."
  default     = "0.0.0.0/0"
}

variable "app_port" {
  type        = number
  description = "Port exposed by the EnviroTrack API."
  default     = 8000
}

variable "zabbix_agent_port" {
  type        = number
  description = "Port used by the Zabbix agent."
  default     = 10050
}

resource "aws_security_group" "envirotrack_sg" {
  name        = "envirotrack-sg"
  description = "Security group for EnviroTrack API host"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.zabbix_agent_port
    to_port     = var.zabbix_agent_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "envirotrack-sg"
  }
}

resource "aws_instance" "envirotrack_host" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.envirotrack_sg.id]

  tags = {
    Name = "envirotrack-host"
  }
}

resource "aws_eip" "envirotrack_host_ip" {
  instance = aws_instance.envirotrack_host.id
  domain   = "vpc"

  tags = {
    Name = "envirotrack-host-eip"
  }
}

output "instance_public_ip" {
  description = "Stable public IP used to reach the EnviroTrack host."
  value       = aws_eip.envirotrack_host_ip.public_ip
}

output "instance_id" {
  description = "EC2 instance ID for the EnviroTrack host."
  value       = aws_instance.envirotrack_host.id
}

output "app_url" {
  description = "Base URL for the EnviroTrack API."
  value       = "http://${aws_eip.envirotrack_host_ip.public_ip}:${var.app_port}"
}
