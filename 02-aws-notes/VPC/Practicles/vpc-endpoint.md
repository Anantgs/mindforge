### VPC Endpoint

[VPC-ENDPOINT](images/vpc-endpoint.png)

- Before creating the VPC endpoint itself, it's important to note the preceding setup demonstrated in the source that enables the endpoint's functionality:

*   **VPC Creation** A Virtual Private Cloud (VPC) named **`demo VPC endpoint VPC`** with an IP range of **`11.0.0.0/16`** was created.
*   **Subnet Creation** Within this VPC, **four subnets** were set up:
    *   Two public subnets with ranges **`11.0.1.0/24`** and **`11.0.2.0/24`** in different Availability Zones (e.g., Europe West 1a and 1b).
    *   Two private subnets with ranges **`11.0.3.0/24`** and **`11.0.4.0/24`** in different Availability Zones (e.g., Europe West 1a and 1b).
*   **Internet Gateway (IGW) Creation and Attachment** An Internet Gateway named **`VPC end point igw`** was created and attached to the `demo VPC endpoint VPC`.
*   **Route Table Configuration** Two route tables were established:
    *   A **public route table** (`VPC end point demo public route table`) associated with the `demo VPC endpoint VPC`. It was configured to associate with the public subnets and have a route to the Internet Gateway (`0.0.0.0/0`) for internet access.
    *   A **private route table** (`private route table`) also associated with the `demo VPC endpoint VPC`. It was configured to associate with the private subnets, but notably, it was **not attached to the Internet Gateway** to keep the subnets private.
*   **EC2 Instance Deployment** EC2 instances were launched: one in a public subnet and one in a private subnet. The private EC2 instance was used to demonstrate the need for and the functionality of the VPC endpoint for accessing AWS services like S3 from a private network.

Once these prerequisites are in place, here is the step-by-step procedure to create a VPC endpoint to access an S3 bucket from within your private network without traversing the internet:

1.  **Navigate to the VPC Dashboard**:
    *   Go to your **AWS console homepage**.
    *   In the search box, type `VPC` and click on the **VPC** service.
2.  **Access Endpoints**:
    *   In the left navigation menu of the VPC dashboard, scroll down and click on **Endpoints**.
3.  **Initiate Endpoint Creation**:
    *   Click the **Create endpoint** button.
4.  **Configure Endpoint Details**:
    *   **Name tag**: Provide a descriptive name for your endpoint, such as **`demo end point`**.
    *   **Service category**: Ensure **AWS services** is selected.
    *   **Service**: In the search box, type `S3`. You need to select the **Gateway** type endpoint for S3, which will appear as `com.amazonaws.your-region.s3` (e.g., **`com.amazonaws.eu-west-1.s3`** for Ireland region). Make sure to choose the correct region you are working in.
    *   **VPC**: From the dropdown, select the VPC where your private resources are located (e.g., **`demo VPC endpoint VPC`**).
    *   **Route tables**: This is a critical step. Under this section, you need to select the **private route table** that is associated with your private subnets. This allows resources within those private subnets (like the private EC2 instance) to use the VPC endpoint to reach S3.
5.  **Create the Endpoint**:
    *   Once all details are configured, click on **Create VPC endpoint**.

After creation, the VPC endpoint will initially be in a **pending state** and will become **available** after a few minutes.

**Verification**:
To confirm the VPC endpoint is functioning, you can log in to your private EC2 instance (which is in a private subnet with the private route table associated with the endpoint) and run the command **`aws s3 ls`**. If configured correctly, this command will **successfully list your S3 buckets**, demonstrating that the private EC2 instance can communicate with S3 without traversing the public internet.