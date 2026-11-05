To establish hybrid connectivity between Google Cloud (GCP) and AWS, several key components are created on both sides.

Here are the components set up on each cloud provider:

**On the AWS Side:**
*   **VPC (Virtual Private Cloud)**: This is the fundamental network environment where AWS resources are launched. A VPC named "AWS VPC hybrid VPC" with a CIDR range of `10.0.0.0/16` is created.

*   **Subnets**: Within the VPC, specific IP address ranges are defined as subnets. Two subnets are created:
    *   A **public subnet** named "AWS VPC hybrid public subnet" with a CIDR range of `10.0.1.0/24`.
    *   A **private subnet** with a CIDR range of `10.0.2.0/24`.

*   **Internet Gateway (IGW)**: This allows communication between the VPC and the internet. An internet gateway named "hybrid igw" is created and then attached to the AWS VPC.

*   **Route Tables**: These define rules for network traffic. Two route tables are created:
    *   A **public route table** named "hybrid public RT" is created and associated with the public subnet. A route to the internet (`0.0.0.0`) via the Internet Gateway is added to this table.
    *   A **private route table** named "private" is created and associated with the private subnet.

*   **EC2 Instances (Virtual Machines)**: Virtual machines are launched to test connectivity. Two instances are created:
    *   A **public EC2 instance** in the public subnet.
    *   A **private EC2 instance** in the private subnet, which does not have a public IP.

*   **Customer Gateways (CGW)**: These represent the customer's side of a VPN connection (in this case, the Google Cloud VPN gateway). Two customer gateways are created using the public IP addresses of the Google Cloud VPN interfaces and an ASN of `64512` (the same ASN used on GCP).

*   **Virtual Private Gateway (VPG)**: This is the AWS side of a VPN connection. A virtual private gateway is created with an ASN of `64513` and then attached to the AWS VPC.

*   **Site-to-Site VPN Connections**: Two VPN connections are created, linking the customer gateways (GCP's side) to the virtual private gateway (AWS's side). These connections facilitate the establishment of VPN tunnels. Route propagation is enabled on both public and private route tables to allow routes from the Google Cloud VPC to propagate dynamically to AWS.

**On the Google Cloud (GCP) Side:**

*   **VPC Network**: This is the isolated network environment in GCP. A VPC network named "gcp VPC hybrid VPC demo connectivity" is created.

*   **Subnets**: Two subnets are created within the GCP VPC:
    *   A **public subnet** named "gcp VPC hybrid public subnet" in the Europe north one region, with a CIDR range of `21.0.1.0/24`.
    *   A **private subnet** in the same region, with a CIDR range of `21.0.2.0/24`.
*   **VM Instances (Virtual Machines)**: A virtual machine named "gcp public VM" is spun up in the public subnet to test connectivity.

*   **Cloud Router**: This manages BGP (Border Gateway Protocol) sessions for dynamic routing with the on-premises network or another cloud provider. A cloud router named "gcp AWS router" is created within the GCP VPC in the Europe North region, with an ASN (Autonomous System Number) of `64512`. It's configured to advertise all subnets visible to it.

*   **High Availability VPN Gateway**: This provides a highly available VPN connection to the AWS side. A VPN gateway named "gcp AWS VPN Gateway" is created within the GCP VPC in the Europe north one region, supporting IPv4 single stack. This gateway provides two interface public IP addresses that are used when configuring customer gateways on the AWS side.

*   **VPN Tunnels**: Four VPN tunnels are set up, corresponding to the two VPN connections on AWS. These tunnels are configured with details from the downloaded AWS VPN configuration files, including pre-shared keys and specific virtual private gateway IP addresses.

*   **BGP Sessions**: Four BGP sessions are configured, one for each VPN tunnel, using the peer ASN of `64513` (from AWS) and specific internal IP addresses from the downloaded AWS configuration.


