resource "aws_eip" "envirotrack_host_ip" {
  instance = aws_instance.envirotrack_host.id
  domain   = "vpc"

  tags = {
    Name = "envirotrack-host-eip"
  }
}
