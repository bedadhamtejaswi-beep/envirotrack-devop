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
