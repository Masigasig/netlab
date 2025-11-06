# Preparing to Send Data

### Preparing to Send Data

When preparing to send data, the host first constructs an IP header (Layer 3),
which contains the source and destination IP addresses.

This ensures end-to-end delivery. However, because IP addresses cannot directly interact
with the physical network, the host also needs a MAC address for delivery at the data link layer (Layer 2).

![Host to Host 1](resource:assets/learning_material/images/chapter_3/host-to-host1.png)
*IP and MAC addresses work together to deliver data*

> IP handles logical addressing (Layer 3), while MAC handles physical delivery (Layer 2).