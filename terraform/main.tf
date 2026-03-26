provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Project = "envirotrack"
    Managed = "terraform"
  }
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
    cidr_blocks = [var.app_allowed_cidr]
  }

  ingress {
    from_port   = var.zabbix_agent_port
    to_port     = var.zabbix_agent_port
    protocol    = "tcp"
    cidr_blocks = [var.zabbix_allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "envirotrack-sg"
  })
}

resource "aws_instance" "envirotrack_host" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.envirotrack_sg.id]
  monitoring             = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  tags = merge(local.common_tags, {
    Name = "envirotrack-host"
  })
}
