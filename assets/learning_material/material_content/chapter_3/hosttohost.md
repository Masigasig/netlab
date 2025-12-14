# Host-to-Host Communication

### What is a Host

A host is any device connected to a network that can send or receive data. This includes computers, laptops, smartphones, printers, servers, and other network-enabled devices. Essentially, any device that participates in network communication qualifies as a host.

### Core Components of a Host

**Network Interface Card (NIC)**

* Each host has a NIC that provides a **unique MAC (Media Access Control) address**.

* The MAC address identifies the device at the hardware level, ensuring that data reaches the correct physical device on a local network.

**IP Address**

* Each host also has an **IP (Internet Protocol) address**, which provides a logical address.

* The IP address allows the host to **communicate across networks**, not just locally.

**Subnet Mask**

* Works with the IP address to determine whether another device is on the **same local network (subnet) or a different subnet**.

* This helps the host decide whether to send data directly or via a router.

### How Communication Works

**Communication within the Same Subnet:**
Hosts can communicate directly, using MAC addresses to deliver data packets. No router is needed.

**Communication Across Subnets:**
If the destination host is on a different subnet, the sending host must forward data to a default gateway (usually a router). The router then directs the packet to the correct network.

### Efficiency Considerations

* Hosts use ARP (Address Resolution Protocol) to map IP addresses to MAC addresses before sending data.

* Once the mapping is cached, subsequent communication is faster because repeated ARP requests are not needed until the cache expires.

> Hosts rely on both IP addresses (logical) and MAC addresses (physical) for communication.