# Address Resolution Protocol (ARP)

### Address Resolution Protocol (ARP)

To map IP addresses to MAC addresses, the host uses the Address Resolution Protocol (ARP).

An ARP Request is broadcast to all devices on the local network, asking which device owns a specific IP address.

The correct device responds with its MAC address in an ARP Reply. Both devices then store the mapping in their ARP caches for faster communication in the future.

![Host to Host 2](resource:assets/learning_material/images/chapter_3/host-to-host2.png)
*ARP maps IP addresses to MAC addresses through requests and replies*

> ARP is essential for discovering the physical MAC address associated with a given IP address.