# Introduction to Switching

### Introduction to Switching

A switch is a device that moves (switches) data between devices inside the same network (LAN).
Unlike a router, which connects different networks, a switch only works within one network.
It uses MAC addresses (the hardware addresses of network cards) to figure out which device should receive the data.

Every device (host) has two key addresses:
an IP Address at Layer 3 (Network Layer) for identifying devices across different networks,
and a MAC Address at Layer 2 (Data Link Layer) for identifying devices inside the same network.
Switches only care about the MAC Address. From the switch’s perspective, the IP Address is just data inside the packet.

> In short: “Routers care about IP addresses”, while “Switches care about MAC addresses”.