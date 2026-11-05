# Provider configuration for multiple regions
# Default provider (required for Route 53 resources like health checks)
provider "aws" {
  region  = "us-east-1"
  profile = "kd"
}

provider "aws" {
  alias   = "primary"
  region  = "us-east-1"
  profile = "kd"
}

provider "aws" {
  alias   = "secondary"
  region  = "us-west-2"
  profile = "kd"
}

# Security Group for Primary (US East)
resource "aws_security_group" "web_sg_primary" {
  provider    = aws.primary
  name        = "failover-demo-web-sg-primary"
  description = "Allow HTTP traffic for failover demo"

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
    Name = "failover-demo-sg-primary"
  }
}

# Security Group for Secondary (US West)
resource "aws_security_group" "web_sg_secondary" {
  provider    = aws.secondary
  name        = "failover-demo-web-sg-secondary"
  description = "Allow HTTP traffic for failover demo"

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
    Name = "failover-demo-sg-secondary"
  }
}

# Data source for Amazon Linux 2 AMI in US East
data "aws_ami" "amazon_linux_primary" {
  provider    = aws.primary
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

# Data source for Amazon Linux 2 AMI in US West
data "aws_ami" "amazon_linux_secondary" {
  provider    = aws.secondary
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

# Primary EC2 Instance in US East
resource "aws_instance" "web_primary" {
  provider               = aws.primary
  ami                    = data.aws_ami.amazon_linux_primary.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg_primary.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              
              # Create health check endpoint
              cat > /var/www/html/health <<'HEALTH'
              OK
              HEALTH
              
              # Create main page
              cat > /var/www/html/index.html <<'HTML'
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Failover Demo - PRIMARY</title>
                  <style>
                      body {
                          font-family: Arial, sans-serif;
                          display: flex;
                          justify-content: center;
                          align-items: center;
                          height: 100vh;
                          margin: 0;
                          background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
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
                      .status { 
                          font-weight: bold; 
                          color: #FFD700;
                          font-size: 2em;
                      }
                      .badge {
                          background: #28a745;
                          padding: 10px 20px;
                          border-radius: 25px;
                          display: inline-block;
                          margin: 20px 0;
                      }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1>🟢 Route 53 Failover Demo</h1>
                      <div class="badge">PRIMARY SERVER</div>
                      <p class="status">ACTIVE</p>
                      <p>Region: US East (N. Virginia)</p>
                      <p>us-east-1</p>
                      <p style="font-size: 1em; margin-top: 30px;">
                          This is the primary server.<br>
                          All traffic routes here when healthy.
                      </p>
                  </div>
              </body>
              </html>
              HTML
              EOF

  tags = {
    Name   = "failover-demo-primary"
    Region = "us-east-1"
    Role   = "Primary"
    Demo   = "Route53-Failover"
  }
}

# Elastic IP for Primary Instance
resource "aws_eip" "primary" {
  provider = aws.primary
  instance = aws_instance.web_primary.id
  domain   = "vpc"

  tags = {
    Name = "failover-demo-primary-eip"
  }
}

# Secondary EC2 Instance in US West
resource "aws_instance" "web_secondary" {
  provider               = aws.secondary
  ami                    = data.aws_ami.amazon_linux_secondary.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg_secondary.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              
              # Create health check endpoint
              cat > /var/www/html/health <<'HEALTH'
              OK
              HEALTH
              
              # Create main page
              cat > /var/www/html/index.html <<'HTML'
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Failover Demo - SECONDARY</title>
                  <style>
                      body {
                          font-family: Arial, sans-serif;
                          display: flex;
                          justify-content: center;
                          align-items: center;
                          height: 100vh;
                          margin: 0;
                          background: linear-gradient(135deg, #ff6b6b 0%, #feca57 100%);
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
                      .status { 
                          font-weight: bold; 
                          color: #FFD700;
                          font-size: 2em;
                      }
                      .badge {
                          background: #dc3545;
                          padding: 10px 20px;
                          border-radius: 25px;
                          display: inline-block;
                          margin: 20px 0;
                      }
                      .alert {
                          background: rgba(255, 255, 255, 0.2);
                          padding: 15px;
                          border-radius: 10px;
                          margin-top: 20px;
                      }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1>🔴 Route 53 Failover Demo</h1>
                      <div class="badge">SECONDARY SERVER</div>
                      <p class="status">FAILOVER ACTIVATED</p>
                      <p>Region: US West (Oregon)</p>
                      <p>us-west-2</p>
                      <div class="alert">
                          <p style="font-size: 1em; margin: 0;">
                              ⚠️ You are seeing this because<br>
                              the PRIMARY server is unhealthy!
                          </p>
                      </div>
                  </div>
              </body>
              </html>
              HTML
              EOF

  tags = {
    Name   = "failover-demo-secondary"
    Region = "us-west-2"
    Role   = "Secondary"
    Demo   = "Route53-Failover"
  }
}

# Elastic IP for Secondary Instance
resource "aws_eip" "secondary" {
  provider = aws.secondary
  instance = aws_instance.web_secondary.id
  domain   = "vpc"

  tags = {
    Name = "failover-demo-secondary-eip"
  }
}

# Route 53 Health Check for Primary Instance
resource "aws_route53_health_check" "primary" {
  ip_address        = aws_eip.primary.public_ip
  port              = 80
  type              = "HTTP"
  resource_path     = "/health"
  failure_threshold = 3
  request_interval  = 30

  tags = {
    Name = "failover-demo-primary-health-check"
  }
}

# Route 53 Health Check for Secondary Instance (optional but recommended)
resource "aws_route53_health_check" "secondary" {
  ip_address        = aws_eip.secondary.public_ip
  port              = 80
  type              = "HTTP"
  resource_path     = "/health"
  failure_threshold = 3
  request_interval  = 30

  tags = {
    Name = "failover-demo-secondary-health-check"
  }
}

# Outputs
output "primary_instance_id" {
  value       = aws_instance.web_primary.id
  description = "Instance ID of Primary server"
}

output "primary_public_ip" {
  value       = aws_eip.primary.public_ip
  description = "Public IP of Primary server (Elastic IP)"
}

output "primary_eip_allocation_id" {
  value       = aws_eip.primary.id
  description = "Allocation ID of Primary Elastic IP"
}

output "primary_public_dns" {
  value       = aws_instance.web_primary.public_dns
  description = "Public DNS of Primary server"
}

output "secondary_instance_id" {
  value       = aws_instance.web_secondary.id
  description = "Instance ID of Secondary server"
}

output "secondary_public_ip" {
  value       = aws_eip.secondary.public_ip
  description = "Public IP of Secondary server (Elastic IP)"
}

output "secondary_eip_allocation_id" {
  value       = aws_eip.secondary.id
  description = "Allocation ID of Secondary Elastic IP"
}

output "secondary_public_dns" {
  value       = aws_instance.web_secondary.public_dns
  description = "Public DNS of Secondary server"
}

output "primary_health_check_id" {
  value       = aws_route53_health_check.primary.id
  description = "Health Check ID for Primary"
}

output "secondary_health_check_id" {
  value       = aws_route53_health_check.secondary.id
  description = "Health Check ID for Secondary"
}

output "demo_instructions" {
  value = <<-EOT
  
  ========================================
  Route 53 Failover Demo - Next Steps
  ========================================
  
  1. Test the instances directly:
     PRIMARY:   http://${aws_eip.primary.public_ip}
     SECONDARY: http://${aws_eip.secondary.public_ip}
     
  2. Test health check endpoints:
     PRIMARY:   http://${aws_eip.primary.public_ip}/health
     SECONDARY: http://${aws_eip.secondary.public_ip}/health
  
  3. Create Route 53 Hosted Zone and Failover Records:
     - Create a hosted zone for your domain
     - Create PRIMARY A record:
       * Name: failover.yourdomain.com
       * Type: A
       * Value: ${aws_eip.primary.public_ip}
       * Routing Policy: Failover
       * Failover Record Type: Primary
       * Health Check: ${aws_route53_health_check.primary.id}
       * Record ID: primary-server
     
     - Create SECONDARY A record:
       * Name: failover.yourdomain.com (SAME name)
       * Type: A
       * Value: ${aws_eip.secondary.public_ip}
       * Routing Policy: Failover
       * Failover Record Type: Secondary
       * Health Check: ${aws_route53_health_check.secondary.id}
       * Record ID: secondary-server
  
  4. Test Failover:
     - Browse to http://failover.yourdomain.com (should show PRIMARY - green)
     - Stop primary instance: aws ec2 stop-instances --instance-ids ${aws_instance.web_primary.id}
     - Wait 2-3 minutes for health check to fail
     - Refresh browser (should show SECONDARY - red/orange)
     - Start primary instance: aws ec2 start-instances --instance-ids ${aws_instance.web_primary.id}
     - Wait for health check to recover
     - Should automatically failback to PRIMARY
  
  ========================================
  EOT
}
