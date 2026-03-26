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

variable "root_volume_size" {
  type        = number
  description = "Root EBS volume size in GiB for the EnviroTrack host."
  default     = 16

  validation {
    condition     = var.root_volume_size >= 8
    error_message = "root_volume_size must be at least 8 GiB."
  }
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

  validation {
    condition     = can(cidrhost(var.allowed_cidr, 0))
    error_message = "allowed_cidr must be a valid IPv4 CIDR block."
  }
}

variable "app_allowed_cidr" {
  type        = string
  description = "CIDR allowed to reach the EnviroTrack API."
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrhost(var.app_allowed_cidr, 0))
    error_message = "app_allowed_cidr must be a valid IPv4 CIDR block."
  }
}

variable "zabbix_allowed_cidr" {
  type        = string
  description = "CIDR allowed to reach the Zabbix agent."
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrhost(var.zabbix_allowed_cidr, 0))
    error_message = "zabbix_allowed_cidr must be a valid IPv4 CIDR block."
  }
}

variable "app_port" {
  type        = number
  description = "Port exposed by the EnviroTrack API."
  default     = 8000

  validation {
    condition     = var.app_port >= 1 && var.app_port <= 65535
    error_message = "app_port must be between 1 and 65535."
  }
}

variable "zabbix_agent_port" {
  type        = number
  description = "Port used by the Zabbix agent."
  default     = 10050

  validation {
    condition     = var.zabbix_agent_port >= 1 && var.zabbix_agent_port <= 65535
    error_message = "zabbix_agent_port must be between 1 and 65535."
  }
}
