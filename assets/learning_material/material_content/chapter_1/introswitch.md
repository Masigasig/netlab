# Introduction to Switching

### How Devices Communicate Inside a Local Network

A **network switch is a device that forwards data between devices within the same local network (LAN)**. Its primary role is to ensure that data sent by one device reaches the **correct destination device**, instead of being sent to everyone.

Unlike a router, which **connects different networks**, a switch operates **only inside a single network**. This makes switches ideal for connecting multiple hosts—such as computers, printers, and servers—within a LAN.

**How a Switch Makes Decisions:**

* Switches operate at **Layer 2 (Data Link Layer)** of the OSI model.

* They use **MAC addresses** (hardware addresses assigned to network interfaces) to decide where to forward data frames.

* When a switch receives data, it checks the destination MAC address and sends the frame **only to the correct port**, reducing unnecessary traffic.

**MAC Address vs IP Address:**

* **MAC Address (Layer 2)**: Identifies devices within the same local network.

* **IP Address (Layer 3)**: Identifies devices across different networks.

* Switches **do not use IP addresses** to make forwarding decisions—the IP address is treated as data inside the frame.

> Routers forward data using IP addresses, while switches forward data using MAC addresses.

**Why Switching Improves Performance:**

* Each device connected to a switch has its **own collision domain**.

* This **allows multiple devices to communicate at the same time without collisions**, making the network faster and more efficient than using a hub.