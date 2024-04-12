
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

resource "aws_iam_instance_profile" "ec2" {
  name = "connect_ec2_to_rds" 
}

resource "aws_instance" "myec2" {
  count                = var.instance_count
  ami                  = var.ami
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2.name

  tags = {
    Name = "ticket_egypt_${count.index + 1}"
  }
}

resource "aws_security_group" "mySG" {
  name   = "sg"
  vpc_id = aws_vpc.myvpc.id


  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  // Outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
}


# role.tf 

# 1- create the instance profile attached to the ec2 instance 
# 2- create the iam_policy 
# 3- create role policy attachment that required the arn of both policy and role 

resource "aws_iam_policy" "ec2_to_rds_policy" {
  name        = "EC2ToRDSAccessPolicy"
  description = "Allows EC2 instance to connect to RDS PostgreSQL instance"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "rds-db:connect"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_to_rds_attachment" {
  policy_arn = aws_iam_policy.ec2_to_rds_policy.arn
  role       = aws_iam_instance_profile.ec2.arn
}

