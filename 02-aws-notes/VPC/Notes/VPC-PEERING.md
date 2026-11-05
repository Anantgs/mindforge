* Peering is Non-Transitive

* Let’s say:

    *   A peering exists between VPC-A ↔ VPC-B and VPC-B ↔ VPC-C.
    
    *   You cannot send traffic from VPC-A to VPC-C through VPC-B. Why?
       
    *   Behind the scenes:
       
    *   AWS maintains a flat, one-to-one tunnel — no forwarding or chaining happens.
       
    *   No routing logic in VPC-B will forward the packet between two peering connections.

* Why transit gateway is transitive and not vpc peering?

* Since Target Gateway is the central point of control and owns the routing logic, it can make intelligent routing decisions and forward traffic to any other connected network — thus enabling transitive communication.

* In peering there is no centralized route processing.