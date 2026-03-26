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
