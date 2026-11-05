#! /bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd 
echo "<html><h1>Welcome to my EC2 instance!</h1></html>" | sudo tee /var/www/html/index.html
sudo systemctl restart httpd
echo "Apache web server installed and running. Visit your EC2 instance's public IP to see"
sudo yum install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm