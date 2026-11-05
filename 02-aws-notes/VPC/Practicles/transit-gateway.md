

### Step-by-Step Procedure to Create a Transit Gateway

[Transit-Gateway](images/transit-gateway.png)

The process involves setting up your individual VPCs first, then deploying the Transit Gateway, attaching your VPCs to it, and finally configuring the routing.

#### 1. Set Up Your Individual VPCs (Repeat for each VPC)
Before creating the Transit Gateway, you need to have your VPCs ready. The demo typically uses three VPCs: `Test VPC 1`, `Test VPC 2`, and `Test VPC 3`, each with **distinct CIDR ranges** to avoid overlap.

*   **Create a VPC**:
    *   In the AWS console, navigate to VPC and click **"Create VPC"**.
    *   Choose **"VPC only"**.
    *   **Name your VPC** (e.g., `Test VPC 1`).
    *   Assign a **CIDR range** (e.g., `12.0.0.0/16` for `Test VPC 1`, `13.0.0.0/16` for `Test VPC 2`, and `14.0.0.0/16` for `Test VPC 3`). Ensure these ranges are different.
    *   Click **"Create VPC"**.

*   **Create an Internet Gateway (IGW)**:
    *   In the VPC dashboard, go to **"Internet Gateways"** and click **"Create Internet Gateway"**.
    *   Give it a **name** (e.g., `test internet gateway for VPC 1`).
    *   Click **"Create Internet Gateway"**.
    *   Once created, **attach it to its respective VPC** (e.g., `Test VPC 1`) via the **"Actions"** menu.

*   **Create a Subnet**:
    *   Navigate to **"Subnets"** in the VPC dashboard and click **"Create Subnet"**.
    *   **Select the VPC** you are working with (e.g., `Test VPC 1`).
    *   Provide a **name** for your subnet (e.g., `test subnet VPC 1`).
    *   Choose an **Availability Zone** (e.g., `Europe Central 1a`).
    *   Specify a **CIDR range** for the subnet, ensuring it's within the VPC's CIDR range (e.g., `12.0.1.0/24` for `Test Subnet VPC 1`).
    *   Click **"Create Subnet"**.

*   **Create a Route Table**:
    *   Go to **"Route Tables"** in the VPC dashboard and click **"Create Route Table"**.
    *   **Name it** (e.g., `test RT for VPC 1`).
    *   **Associate it with its VPC** (e.g., `Test VPC 1`).
    *   Click **"Create Route Table"**.

*   **Associate Route Table with Subnet**:
    *   Select your newly created route table (e.g., `test RT for VPC 1`).
    *   Go to **"Subnet Associations"**, click **"Edit subnet associations"**, and **select the subnet** you created for this VPC (e.g., `test subnet VPC 1`). Then, **"Save Association"**.

*   **Add Internet Route to Route Table**:
    *   While on the route table, go to **"Routes"**, click **"Edit routes"**, and **"Add route"**.
    *   For the destination, enter `0.0.0.0/0` (for internet access).
    *   For the target, select the **Internet Gateway** you created for this VPC (e.g., `internet gateway test VPC 1`).
    *   Click **"Save changes"**.

*   **Launch an EC2 Instance**:
    *   Go to the EC2 dashboard and click **"Launch instances"**.
    *   **Name your instance** (e.g., `ec2 test vpc1`).
    *   Choose an **AMI** (e.g., Ubuntu) and **instance type** (e.g., `t2.micro`).
    *   **Create a new key pair** for SSH access (e.g., `ec2 test vpc1 key`) and download the private key.
    *   In **"Network settings"**:
        *   Select the **VPC** you're configuring (e.g., `Test VPC 1`).
        *   Choose the **subnet** created for this VPC.
        *   **Enable "Auto-assign public IP"** for direct SSH access.
        *   Configure **Security Groups** to allow SSH (Port 22) and HTTP (Port 80) from anywhere for testing purposes.
    *   In **"Advanced details"**, use a **user data script** to install Apache or a similar application for communication testing.
    *   Click **"Launch instance"**.
    *   **Verify Apache installation** by accessing the public IP of your EC2 instance in a web browser.

    **Repeat all the above VPC setup steps for `Test VPC 2` and `Test VPC 3`**, ensuring you use their respective CIDR ranges, subnet ranges, and naming conventions to differentiate resources.

#### 2. Create the Transit Gateway
*   In the AWS console, navigate to VPC and scroll down to **"Transit Gateways"**.
*   Click **"Create Transit Gateway"**.
*   **Provide a name** (e.g., `Transit Gateway TG VPC1 VPC2 VPC3`).
*   For the **Amazon Side Autonomous System Number (ASN)**, you can leave it blank for AWS to assign one. However, it is a recommended best practice by AWS to **configure unique ASNs for every Transit Gateway** to allow for future enhancements, such as potential route advertisement improvements over peering.
*   Leave other options as default for a simple setup.
*   Click **"Create Transit Gateway"**. It will enter a "pending" state and become "available" after a few minutes.

#### 3. Create Transit Gateway Attachments (for each VPC)
Once the Transit Gateway is available, you need to attach your VPCs to it.
*   In the Transit Gateway section, go to **"Transit Gateway Attachments"**.
*   Click **"Create Transit Gateway Attachment"**.
*   **Name the attachment** (e.g., `Transit Gateway attachment VPC 1`).
*   Select the **Transit Gateway ID** you just created.
*   Choose **"VPC"** as the attachment type.
*   **Select the VPC** you want to attach (e.g., `Test VPC 1`).
*   **Select all subnets** within that VPC that you want to participate in the Transit Gateway routing.
*   Click **"Create Transit Gateway Attachment"**.
*   **Repeat this process for all other VPCs** (`Test VPC 2` and `Test VPC 3`), creating a separate attachment for each.

#### 4. Modify VPC Route Tables (Critical Step)
**This is a crucial step** because, unlike automatic route propagation within a single Transit Gateway's default route table, **routes are NOT automatically shared across Transit Gateway peering connections**. You must explicitly add routes in each VPC's route table to direct traffic destined for other peered VPCs towards the Transit Gateway attachment.

*   In the AWS console, go to **"Route Tables"** under VPC.
*   Select the route table associated with **`Test VPC 1`** (e.g., `test RT for VPC 1`).
*   Go to **"Routes"**, click **"Edit routes"**, and **"Add route"**.
    *   For the destination, add the **CIDR range of `Test VPC 2`** (e.g., `13.0.0.0/16`).
    *   For the target, select the **Transit Gateway attachment for `Test VPC 1`** (e.g., `Transit Gateway attachment VPC 1`).
    *   **Add another route** for the **CIDR range of `Test VPC 3`** (e.g., `14.0.0.0/16`), also directing it to the **Transit Gateway attachment for `Test VPC 1`**.
    *   Click **"Save changes"**.

*   **Repeat this process for `Test VPC 2`'s route table**:
    *   Add routes for `Test VPC 1`'s CIDR (`12.0.0.0/16`) and `Test VPC 3`'s CIDR (`14.0.0.0/16`), directing both to `Test VPC 2`'s Transit Gateway attachment.
*   **Repeat this process for `Test VPC 3`'s route table**:
    *   Add routes for `Test VPC 1`'s CIDR (`12.0.0.0/16`) and `Test VPC 2`'s CIDR (`13.0.0.0/16`), directing both to `Test VPC 3`'s Transit Gateway attachment.

#### 5. Verify Communication
*   **SSH into the EC2 instances** in each VPC.
*   From an EC2 instance in `Test VPC 1`, use `curl` to access the private IP address of an EC2 instance in `Test VPC 2` and `Test VPC 3`.
*   Similarly, test connectivity from `Test VPC 2` to `Test VPC 1` and `Test VPC 3`, and from `Test VPC 3` to `Test VPC 1` and `Test VPC 2`.
*   A successful response confirms that the Transit Gateway is correctly routing traffic between your VPCs. Data transfer over the Transit Gateway is encrypted over the global AWS network, similar to VPC peering.

**Transit Gateway vs. VPC Peering**:
It's important to understand that while VPC peering connects two VPCs directly, requiring a new peering connection for every pair of VPCs, **Transit Gateway offers a hub-and-spoke architecture**. This means you create a single Transit Gateway and connect all your VPCs to it. This approach is significantly more efficient for managing connectivity among a large number of VPCs, as it reduces the complexity of managing multiple peering connections and their associated route tables.