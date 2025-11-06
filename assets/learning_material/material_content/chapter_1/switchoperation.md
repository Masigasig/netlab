# Switch Operations

### Switch Operations (Learn, Flood, Forward)

To occupy the MAC Address Table, the switch performs three key operations: Learn, Flood, and Forward.

#### Learn
When the switch receives a frame (Layer 2 packet), it looks at the source MAC Address.
It records the MAC address and the port it came from. This way, it builds its MAC Address Table.

#### Flood
If the switch does not know the destination MAC address, it sends the frame to all ports (except the incoming port).
This ensures the correct destination receives it. Other devices also see it but ignore it if it is not for them.

#### Forward
If the switch already knows the destination MAC’s port (from its table), it sends the frame directly to that port only.
This makes communication efficient, private, and fast.

> Even when a host sends data to a router instead of another host, the switch still uses the same process — Learn, Flood, and Forward.
The router is simply another device with its own MAC address.