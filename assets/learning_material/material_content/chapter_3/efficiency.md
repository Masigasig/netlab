# Subsequent Communication

### Overview

After the first data exchange between two hosts, **subsequent communication becomes faster** because each host has stored the other’s IP-to-MAC mapping in its ARP cache.

### How It Works

* **ARP Cache Lookup:**
Instead of broadcasting a new ARP Request, the host retrieves the MAC address directly from its cache.

* **Efficiency:**
Reduces network traffic and speeds up packet delivery until the ARP cache entries expire.

![Host to Host 4](resource:assets/learning_material/images/chapter_3/host-to-host4.gif)
*Cached ARP entries improve communication efficiency.*

> Once ARP caches are populated, devices can communicate directly without repeating the ARP request process.