# Switch Frame Types

### Frame Types

A switch sends the frame to all ports if it does not know where the destination MAC Address is.
That frame is called a **Unicast Frame** when it is meant for one device.

#### Unicast Frame
One-to-one communication. Flooding happens only until the switch learns where the device is.
Once the destination MAC is known (in the MAC table), the switch forwards directly to that port.

#### Broadcast Frame
One-to-all communication. The switch always floods the frame to all ports, regardless of its MAC Address Table.

> When a host sends an “ARP Request”, it uses a Broadcast Frame.
The destination MAC address is set to all F’s (FF:FF:FF:FF:FF:FF), a reserved address meaning the frame must be delivered to every host in the local network.