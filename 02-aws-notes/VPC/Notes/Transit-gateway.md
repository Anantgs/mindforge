* What is a Transit Gateway?

* An AWS Transit Gateway (TGW) is a highly scalable, cloud-native router that allows you to connect multiple VPCs, on-premises networks, and VPNs together through a centralized hub.

* Instead of making many point-to-point connections between VPCs (called VPC peering), Transit Gateway simplifies this into a hub-and-spoke model.

1. **Behind the Scenes**

* ENIs Get Created in Your VPCs

* When you attach a VPC to a TGW:

* AWS injects ENIs (Elastic Network Interfaces) into each Availability Zone of your VPC.

* These ENIs are connected to the TGW's backend infrastructure and act as entry/exit points for traffic between the VPC and TGW.

* These are managed by AWS — you don’t see or manage the TGW backend itself, only the ENIs.


2. **Traffic Flow Is Controlled by TGW Route Tables**

* TGW has its own route tables — separate from your VPC route tables.

* Each attachment (VPC, VPN, etc.) can be associated with one TGW route table.

* AWS uses these route tables to determine which attachment to forward traffic to.

* Routed through AWS backbone, not the internet.

* Behind the scenes:

    * When traffic leaves a VPC via a TGW attachment, TGW looks up its own route table to figure out where the packet should go.

    * The destination attachment’s ENIs are chosen, and traffic is forwarded via AWS’s private network.

