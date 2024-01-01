
output "IAM-Details" {
  value = {
    username = aws_iam_user.user.name
    arn = aws_iam_user.user.arn
    path = aws_iam_user.user.path
    permissions_boundary = aws_iam_user.user.permissions_boundary
  }
  description = "IAM USER Details"
}
output "Web_Server" {

  value = {
    public_ip = aws_instance.web_server.public_ip
    private_ip = aws_instance.web_server.private_ip
  }
  description = "Public and Private IP addresses of WebServer"
}

output "Database_server" {

  value = {
    public_ip = aws_instance.database_server.public_ip
    private_ip = aws_instance.database_server.private_ip
  }
  description = "Public and Private IP addresses of WebServer"
}

