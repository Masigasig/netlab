# MAC Address Table

### MAC Address Table

Switches use and maintain a “MAC Address Table” to facilitate communication in the network.
The MAC Address Table keeps track of which MAC address is connected to which switch port.

| Port | MAC Address | Device |
|------|-------------|--------|
|Port 3|8A:00:AA:23:B3:4E|Host A|

When a switch is first powered on, its MAC Address Table is empty.
The switch learns MAC addresses dynamically as devices send data through it.
Over time, the table is populated so the switch knows exactly which port to forward data to.

> This process is called “MAC learning”. It allows switches to send frames only to the correct device instead of broadcasting everywhere.