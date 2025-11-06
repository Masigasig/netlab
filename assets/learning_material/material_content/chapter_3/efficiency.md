# Subsequent Communication

### Subsequent Communication

Subsequent communication is faster because the hosts already have each other’s IP-to-MAC mappings in their ARP caches,
eliminating the need for another ARP Request until the cache entries expire.

![Host to Host 4](resource:assets/learning_material/images/chapter_3/host-to-host4.gif)
*Cached ARP entries improve communication efficiency*

> Once ARP caches are populated, devices can communicate directly without repeating the ARP request process.