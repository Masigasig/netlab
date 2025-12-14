# Introduction to Routing

### How Data Moves Between Networks

**Routing** is the process of **forwarding data packets** from one network to another. It allows devices on different networks to communicate, even when they are far apart or use different network segments.

A **router** is a network device whose **primary function is routing**. When a router receives a packet, it examines the **destination IP address** and decides **where to send the packet next** so it can move closer to its final destination.

**Key Characteristics of Routing:**

* Routers operate mainly at **Layer 3 (Network Layer)** of the OSI model.

* Routing decisions are made using **IP addresses**, not MAC addresses.

* Routers **connect separate networks** and forward packets between them.

**What Happens If a Route Is Unknown?**

* If a router does not have a route to the destination network, **it drops the packet**.

* In many cases, it may also send an **ICMP “Destination Unreachable”** message back to the sender.

> **Key Comparison:**
> * **Switches forward data within a single network using MAC addresses.**
> * **Routers forward data between networks using IP addresses.**