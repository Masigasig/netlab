# Switch Frame Types

### How Switches Handle Different Frame Types

Switches forward **Ethernet frames** based on the** destination MAC address**.
Depending on how that destination is defined (or whether it is known), frames are classified into unicast or broadcast types.

### Unicast Frame

A **unicast frame** is a **one-to-one communication** intended for a single destination device.

**How a switch handles unicast frames:**

* If the destination MAC address exists in the MAC Address Table, the switch forwards the frame only to the correct port.

* If the destination MAC address is unknown, the switch floods the frame to all ports except the incoming port.

* Once the destination responds, the switch learns the MAC address and updates its MAC table.

> Flooding of unicast frames happens only when the destination MAC is unknown.

### Broadcast Frame

A **broadcast frame** is a one-to-all communication intended for **every device in the local network.**

**Key characteristics:**

* The switch **always floods** broadcast frames to all ports (except the source port).

* The destination MAC address is **FF:FF:FF:FF:FF:FF**, a reserved broadcast address.

* Broadcast frames are never filtered using the MAC Address Table.

**Common example:**

* **ARP Request** — used when a host needs to discover the MAC address associated with a known IP address.

> **Key takeaway:**
> Switches flood frames only when necessary — either when the destination MAC > is unknown (unicast flooding) or when the frame is explicitly a broadcast.