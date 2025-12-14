# Routing Table

### How a Router Chooses Where to Send Packets

A **routing table** is an internal database used by a router to decide **where to forward packets**. It acts as the router’s map of known networks, guiding packets toward their destination.

Each entry in the routing table is called a **route**. A route tells the router which destination network exists and how to reach it.

### What a Routing Table Entry Contains

A typical routing table entry includes:

* **Destination network** – the network the packet is trying to reach

* **Next hop** – the next router or device to send the packet to

* **Outgoing interface** – the router interface used to forward the packet

> Together, these details allow the router to forward packets efficiently and correctly.

### How Routers Use the Routing Table

* When a packet arrives, the router checks the **destination IP address**.

* It searches the routing table for the best matching route.

* The packet is then forwarded using the specified next hop and outgoing interface.

### Why the Routing Table Is Critical

* If a matching route exists, the packet is **forwarded successfully**.

* If no route is found, the **router drops the packet (often sending an ICMP error)**.

* Keeping the routing table accurate ensures reliable data delivery between networks.

> Think of the routing table as the router’s “cheat sheet” for making fast and correct forwarding decisions.