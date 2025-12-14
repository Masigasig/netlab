# Router Network Connections

### How Routers Connect Multiple Networks

A **router** is designed to connect **two or more separate networks and enable communication between them**. To perform this role, a router must be able to **participate in each connected network** as a unique and identifiable device..

### Router Interfaces

* A router uses **network interfaces** to connect to different networks.

* Each interface represents a **separate connection** to a network.

* A router can have **multiple interfaces**, which is why it is often described as having **“multiple faces.”**

### Addressing on Router Interfaces

Just like a host, a router uses both:

* an **IP address (Layer 3)**, and

* a **MAC address (Layer 2)**

However, unlike a host that belongs to only one network, a **router cannot use the same addresses on all networks.**

**Important rules:**

* **Each router interface must have its own unique IP address.**

* **Each router interface must also have its own unique MAC address.**

* These addresses identify the router **within that specific network only**.

> This per-interface addressing is what allows the router to act as a bridge between otherwise separate networks.

### LAN and WAN Interfaces

* **LAN interfaces** connect the router to **local networks** (such as switches and end devices).

* **WAN interfaces** connect the router to **external networks**, such as the Internet or other remote networks.

* Interfaces can be **physical** (Ethernet, fiber, serial) **or logical** (VLANs, loopbacks).