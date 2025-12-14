# Host vs Router

### Understanding Their Roles in Network Communication

#### Host

A host is any end device on a network, such as a **computer, phone, printer, or server**. Hosts are the **endpoints of communication—they generate, send, receive, and process data for applications**.

**Key characteristics of a host:**

* Has both an **IP address (Layer 3)** and a **MAC address (Layer 2)**.

* **Sends and receives data addressed to itself.**

* **Does not forward traffic** for other devices.

* If a packet arrives with a **destination IP that does not match, the host ignores or drops it**.

> Hosts consume and produce data, but they do not move data between networks.

#### Router

A router is a network device designed to **forward packets between different networks**. While routers also have IP and MAC addresses, their **primary role is forwarding, not consuming**, data.

**Key characteristics of a router:**

* Operates mainly at **Layer 3 (Network Layer)** of the OSI model.

* **Forwards packets that are not addressed to itself.**

* Uses **IP addresses** to determine where packets should go next.

* Connects **multiple networks** and enables communication between them.

> If a packet is destined for another network, a router forwards it instead of dropping it.

> According to RFC 2640: “Internet Protocol, Version 6 (IPv6) Specification,”
'a router is defined as a node (device) that forwards IPv6 packets not explicitly addressed to itself.
Meanwhile, a host is any node (device) that is not a router.