# MAC Address Table

### How a Switch Knows Where to Send Data

A **MAC Address Table** is a data structure used by a **network switch** to **map device MAC addresses to specific switch ports**. This table allows the switch to forward frames accurately and efficiently within a local network.

### What the MAC Address Table Contains

Each entry in the table includes:

* The **MAC address** of a device

* The **switch port** the device is connected to

| Port | MAC Address | Device |
|------|-------------|--------|
|Port 3|8A:00:AA:23:B3:4E|Host A|

### How the Switch Learns MAC Addresses

* When a switch is **first powered on**, the MAC Address Table is **empty**.

* As frames enter the switch, **it examines the source MAC address** of each frame.

* The switch **records the source MAC address** and the **port it arrived on in the MAC Address Table**.

* This automatic process is called **MAC learning**.

> MAC learning allows the switch to remember where devices are located on the network.

### Why the MAC Address Table Is Important

* Once a destination MAC address is known, the switch can forward frames only to the correct port.

* This reduces **unnecessary traffic** and improves overall network performance.

* Without a MAC Address Table, the switch would have to **broadcast frames to all ports**.