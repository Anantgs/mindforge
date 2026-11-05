# Provider configuration for multiple regions
provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "eu_west"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "ap_south_1"
  region = "ap-south-1"
}

# Security Group for US East (N. Virginia)
resource "aws_security_group" "web_sg_us_east" {
  provider    = aws.us_east
  name        = "latency-demo-web-sg-us-east"
  description = "Allow HTTP traffic for latency demo"

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
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
    Name = "latency-demo-sg-us-east"
  }
}

# Security Group for EU West (Ireland)
resource "aws_security_group" "web_sg_eu_west" {
  provider    = aws.eu_west
  name        = "latency-demo-web-sg-eu-west"
  description = "Allow HTTP traffic for latency demo"

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
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
    Name = "latency-demo-sg-eu-west"
  }
}

# Security Group for AP SOUTH (Mumbai)
resource "aws_security_group" "web_sg_ap_south_1" {
  provider    = aws.ap_south_1
  name        = "latency-demo-web-sg-ap-south-1"
  description = "Allow HTTP traffic for latency demo"

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
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
    Name = "latency-demo-sg-ap-south-1"
  }
}

# Data source for Amazon Linux 2 AMI in US East
data "aws_ami" "amazon_linux_us_east" {
  provider    = aws.us_east
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source for Amazon Linux 2 AMI in EU West
data "aws_ami" "amazon_linux_eu_west" {
  provider    = aws.eu_west
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source for Amazon Linux 2 AMI in EU West
data "aws_ami" "amazon_linux_ap_south_1" {
  provider    = aws.ap_south_1
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instance in US East (N. Virginia)
resource "aws_instance" "web_us_east" {
  provider               = aws.us_east
  ami                    = data.aws_ami.amazon_linux_us_east.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg_us_east.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              
              # Create a custom HTML page
              cat > /var/www/html/index.html <<'HTML'
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Latency Demo - US East</title>
                  <style>
                      body {
                          font-family: Arial, sans-serif;
                          display: flex;
                          justify-content: center;
                          align-items: center;
                          height: 100vh;
                          margin: 0;
                          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                          color: white;
                      }
                      .container {
                          text-align: center;
                          padding: 40px;
                          background: rgba(255, 255, 255, 0.1);
                          border-radius: 20px;
                          box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
                      }
                      h1 { font-size: 3em; margin: 0; }
                      p { font-size: 1.5em; margin: 20px 0; }
                      .region { font-weight: bold; color: #FFD700; }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1>🌎 Route 53 Latency Demo</h1>
                      <p>You are connected to:</p>
                      <p class="region">US East (N. Virginia)</p>
                      <p>Region: us-east-1</p>
                  </div>
              </body>
              </html>
              HTML
              EOF

  tags = {
    Name   = "latency-demo-us-east-1"
    Region = "us-east-1"
    Demo   = "Route53-Latency"
  }
}

# EC2 Instance in EU West (Ireland)
resource "aws_instance" "web_eu_west" {
  provider               = aws.eu_west
  ami                    = data.aws_ami.amazon_linux_eu_west.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg_eu_west.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              
              # Create a custom HTML page
              cat > /var/www/html/index.html <<'HTML'
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Latency Demo - EU West</title>
                  <style>
                      body {
                          font-family: Arial, sans-serif;
                          display: flex;
                          justify-content: center;
                          align-items: center;
                          height: 100vh;
                          margin: 0;
                          background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                          color: white;
                      }
                      .container {
                          text-align: center;
                          padding: 40px;
                          background: rgba(255, 255, 255, 0.1);
                          border-radius: 20px;
                          box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
                      }
                      h1 { font-size: 3em; margin: 0; }
                      p { font-size: 1.5em; margin: 20px 0; }
                      .region { font-weight: bold; color: #FFD700; }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1>🌍 Route 53 Latency Demo</h1>
                      <p>You are connected to:</p>
                      <p class="region">EU West (Ireland)</p>
                      <p>Region: eu-west-1</p>
                  </div>
              </body>
              </html>
              HTML
              EOF

  tags = {
    Name   = "latency-demo-eu-west-1"
    Region = "eu-west-1"
    Demo   = "Route53-Latency"
  }
}


# EC2 Instance in AP South (Mumbai)
resource "aws_instance" "web_ap_south" {
  provider               = aws.ap_south_1
  ami                    = data.aws_ami.amazon_linux_ap_south_1.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg_ap_south_1.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              
              # Create a custom HTML page
              cat > /var/www/html/index.html <<'HTML'
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Latency Demo - US East</title>
                  <style>
                      body {
                          font-family: Arial, sans-serif;
                          display: flex;
                          justify-content: center;
                          align-items: center;
                          height: 100vh;
                          margin: 0;
                          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                          color: white;
                      }
                      .container {
                          text-align: center;
                          padding: 40px;
                          background: rgba(255, 255, 255, 0.1);
                          border-radius: 20px;
                          box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
                      }
                      h1 { font-size: 3em; margin: 0; }
                      p { font-size: 1.5em; margin: 20px 0; }
                      .region { font-weight: bold; color: #FFD700; }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1>🌎 Route 53 Latency Demo</h1>
                      <p>You are connected to:</p>
                      <p class="region">AP SOUTH (MUMBAI)</p>
                      <p>Region: ap-south-1</p>
                  </div>
              </body>
              </html>
              HTML
              EOF

  tags = {
    Name   = "latency-demo-us-east-1"
    Region = "us-east-1"
    Demo   = "Route53-Latency"
  }
}

# Outputs
output "us_east_instance_id" {
  value       = aws_instance.web_us_east.id
  description = "Instance ID of US East server"
}

output "us_east_public_ip" {
  value       = aws_instance.web_us_east.public_ip
  description = "Public IP of US East server"
}

output "ap_south_public_ip" {
  value       = aws_instance.web_ap_south.public_ip
  description = "Public IP of AP South server"
}

output "us_east_public_dns" {
  value       = aws_instance.web_us_east.public_dns
  description = "Public DNS of US East server"
}

output "eu_west_instance_id" {
  value       = aws_instance.web_eu_west.id
  description = "Instance ID of EU West server"
}

output "eu_west_public_ip" {
  value       = aws_instance.web_eu_west.public_ip
  description = "Public IP of EU West server"
}

output "eu_west_public_dns" {
  value       = aws_instance.web_eu_west.public_dns
  description = "Public DNS of EU West server"
}

output "ap_south_public_dns" {
  value       = aws_instance.web_ap_south.public_dns
  description = "Public DNS of AP South server"
}

output "demo_instructions" {
  value = <<-EOT
  
  ========================================
  Route 53 Latency Demo - Next Steps
  ========================================
  
  1. Test the instances directly:
     US East: http://${aws_instance.web_us_east.public_ip}
     EU West: http://${aws_instance.web_eu_west.public_ip}
     AP South: http://${aws_instance.web_ap_south.public_ip}
  
  2. Create Route 53 Hosted Zone and Records:
     - Create a hosted zone for your domain
     - Create two A records with the same name (e.g., demo.yourdomain.com)
     - Set routing policy to "Latency"
     - For US East record: Region = us-east-1, Value = ${aws_instance.web_us_east.public_ip}
     - For EU West record: Region = eu-west-1, Value = ${aws_instance.web_eu_west.public_ip}
     - For AP South record: Region = ap-south-1, Value = ${aws_instance.web_ap_south.public_ip}
     - Add health checks (optional but recommended)
  
  3. Test from different locations to see latency-based routing in action!
  
  ========================================
  EOT
}
