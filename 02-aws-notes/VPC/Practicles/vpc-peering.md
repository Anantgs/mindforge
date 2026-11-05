## To establish a VPC peering connection, allowing two Virtual Private Clouds (VPCs) to communicate privately, follow these steps:

[vpc-peering](images/vpc-peering.png)

*   **1. Set Up Your VPCs**:
    *   **Create two separate VPCs** with distinct CIDR ranges. For example, `Test VPC 1` could use `12.0.0.0/16`, and `Test VPC 2` could use `13.0.0.0/16`.

*   **2. Create Route Tables for Each VPC**:
    *   **Generate a unique route table for each VPC**. Name them descriptively, such as `test RT for VPC 1` linked to `Test VPC 1` and `test RT for VPC 2` linked to `Test VPC 2`.

*   **3. Create Subnets within Each VPC**:
    *   **Provision at least one subnet within each VPC**. For instance, create `Test Subnet VPC 1` within `Test VPC 1` using `12.0.1.0/24` and `Test Subnet VPC 2` within `Test VPC 2` using `13.0.1.0/24`.

*   **4. Associate Route Tables with Subnets**:
    *   **Link the respective route tables to their subnets**. For example, associate `test RT for VPC 1` with `Test Subnet VPC 1`. Perform this for both VPCs.

*   **5. Create and Attach Internet Gateways (for public subnets)**:
    *   If internet access is required for your EC2 instances within these subnets, **create an Internet Gateway for each VPC** (e.g., `test internet gateway for VPC 1` and `test internet gateway for VPC 2`).
    *   **Attach each Internet Gateway to its respective VPC**.

*   **6. Configure Internet Routes in Public Route Tables**:
    *   **Add a route** in each public route table directing all internet-bound traffic (`0.0.0.0/0`) to its associated Internet Gateway. This enables public access to resources within these subnets. Perform this for both VPCs.

*   **7. Launch EC2 Instances**:
    *   **Provision an EC2 instance in each VPC's subnet**. Choose an AMI (e.g., Ubuntu) and instance type (e.g., t2.micro).
    *   **Create a new key pair** for SSH access for each instance.
    *   **Configure network settings** to attach the instance to its respective VPC and subnet, ensuring auto-assign public IP is enabled if you need direct SSH access from the internet.
    *   **Set up Security Groups** to allow necessary inbound traffic, such as SSH (Port 22) and HTTP (Port 80) from anywhere, for testing purposes.
    *   **Utilise a user data script** to automatically install an application like Apache when the instance launches, which can be used for communication testing.
    *   **Verify Apache installation** by accessing the public IP of the EC2 instances.

*   **8. Initiate and Accept the Peering Connection**:
    *   Navigate to "Peering Connections" in the AWS VPC console.
    *   **Create a new peering connection**, selecting the requesting VPC (e.g., `VPC 1`) and the accepting VPC (e.g., `VPC 2`).
    *   The connection will initially be in a "pending acceptance" state.
    *   **The destination VPC must then accept the peering request** for the connection to be established. Once accepted, the status will change to "active" or "established".

*   **9. Modify Route Tables for Peering (Critical Step)**:
    *   This is crucial for enabling communication.
    *   For `VPC 1`'s route table, **add a new route** for `VPC 2`'s CIDR range (`13.0.0.0/16`) and **direct it to the newly created peering connection**.
    *   Similarly, for `VPC 2`'s route table, **add a new route** for `VPC 1`'s CIDR range (`12.0.0.0/16`) and **direct it to the peering connection**.
    *   **Without these specific route table entries, communication between instances in the peered VPCs will fail**. It's important to understand that routes are not automatically shared over peering connections; you must configure static routes.

*   **10. Verify Communication**:
    *   **SSH into the EC2 instances** in each VPC.
    *   **Test connectivity between them** using their private IP addresses. For example, from the `VPC 1` EC2 instance, use `curl` to access the private IP address of the EC2 instance in `VPC 2`.
    *   A successful response confirms the peering connection is working. Data transfer over the peering connection is encrypted over the global AWS network.

Note that while Transit Gateway can connect multiple VPCs more efficiently for larger setups (e.g., more than 10 or 50 VPCs), requiring only a single Transit Gateway instead of multiple peering connections, VPC peering is a direct method for connecting two VPCs. Transit Gateway peering also requires static routes, similar to VPC peering.