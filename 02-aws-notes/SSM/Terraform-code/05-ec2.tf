resource "aws_instance" "myec2vm-bastion-vpc-1" {
  depends_on             = [module.vpc.id]
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = "t2.micro"
  key_name               = "eks-terraform-key"
  user_data              = file("app-install.sh")
  vpc_security_group_ids = [ aws_security_group.vpc-ssh-1.id, aws_security_group.vpc-web-1.id ]
  associate_public_ip_address = true
  subnet_id              = module.vpc.public_subnets[0] # Use the first

  tags = {
    "Name" = "bastion-host"
  }
}

resource "aws_instance" "private-host-vpc-1" {
  depends_on             = [module.vpc.id]
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = "t2.micro"
  key_name               = "eks-terraform-key"
  user_data              = file("app-install.sh")
  vpc_security_group_ids = [ aws_security_group.vpc-ssh-1.id, aws_security_group.vpc-web-1.id ]
  associate_public_ip_address = true
  subnet_id              = module.vpc.private_subnets[0] # Use the first private subnet from the VPC module
  iam_instance_profile   = aws_iam_instance_profile.ssm_instance_profile.name

  tags = {
    "Name" = "private-host"
  }
}


