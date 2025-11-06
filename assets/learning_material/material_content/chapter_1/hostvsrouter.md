# Host vs Router

### Host vs Router

#### Host
A host is any device on a network, such as a computer, phone, or printer.
Every host has an IP address and a MAC address to send and receive data.
However, a host only deals with traffic directly addressed to it.
If a packet arrives with a different destination IP, the host ignores or drops it.
In short, hosts are endpoints in communication, not devices that forward traffic.

#### Router
A router also has an IP address and a MAC address, but its main job is very different.
Routers forward packets that are not addressed to themselves.
Instead of dropping packets destined for another network, a router works to pass them along toward their correct destination.

> According to RFC 2640: “Internet Protocol, Version 6 (IPv6) Specification,”
'a router is defined as a node (device) that forwards IPv6 packets not explicitly addressed to itself.
Meanwhile, a host is any node (device) that is not a router.