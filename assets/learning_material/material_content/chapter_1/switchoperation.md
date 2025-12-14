# Switch Operations

### How a Switch Learns and Forwards Frames

A switch builds and uses its **MAC Address Table** by performing three fundamental operations:
**Learn, Flood, and Forward.**
These steps allow the switch to deliver frames efficiently within a local network.

### Learn

When a switch receives an Ethernet frame, it examines the source MAC address.

**What the switch does:**

* Records the source **MAC address**

* Associates it with the incoming port

* Stores this information in the **MAC Address Table**

This process happens automatically and continuously as traffic flows through the switch.

> The switch learns **only from the source MAC**, never from the destination MAC.

### Flood

If the destination MAC address is **not found** in the MAC Address Table, the switch cannot determine where to send the frame.

**What the switch does:**

* Sends (floods) the frame to all ports except the port it arrived on

* The correct device processes the frame

* All other devices receive the frame but **discard it**

> Flooding ensures that unknown devices can still be reached and discovered.

### Forward

If the destination **MAC address exists in the MAC Address Table**, the switch knows exactly where the frame should go.

**What the switch does:**

* Forwards the frame only to the specific port linked to that MAC address

* Does not send the frame to any other ports

This makes **communication faster, more efficient, and more secure.**

> **Key takeaway:**
Switches do not “understand” IP addresses — they simply learn MAC addresses and use them to move frames correctly within the network.