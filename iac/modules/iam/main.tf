
resource "aws_iam_role" "ssm_role" {
  name = "ssm-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "proxy-server-policy-t4"
  }
}


resource "aws_iam_role_policy_attachment" "server_ssm" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "proxy_profile" {
  name = "proxy_profile"
  role = aws_iam_role.ssm_role.name

  tags = {
    Name = "proxy-server-profile-t4"
  }
}


resource "aws_iam_instance_profile" "ansible_profile" {
  name = "proxy_profile"
  role = aws_iam_role.ssm_role.name

  tags = {
    Name = "ansible-server-profile-t4"
  }
}
