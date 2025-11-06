# Host-to-Host Communication

### Host-to-Host Communication

A host is any device connected to a network that can send or receive data.

Each host has a Network Interface Card (NIC) with a unique MAC address for
identification at the hardware level, and an IP address for logical identification across networks.

The subnet mask works with the IP address to determine whether another device is
on the same local network or on a different one.

If the target is on the same subnet, the host communicates directly.
If it is on a different subnet, communication must be passed through a router.

> Hosts rely on both IP addresses (logical) and MAC addresses (physical) for communication.