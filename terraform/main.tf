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

variable "allowed_cidr" {
  type        = string
  description = "CIDR allowed to SSH to the host."
  default     = "0.0.0.0/0"
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
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10050
    to_port     = 10050
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
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.envirotrack_sg.id]

  tags = {
    Name = "envirotrack-host"
  }
}

output "instance_public_ip" {
  value = aws_instance.envirotrack_host.public_ip
}
