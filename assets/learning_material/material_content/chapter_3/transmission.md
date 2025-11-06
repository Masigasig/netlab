# Packet Transmission and Reception

### Packet Transmission and Reception

Once the MAC address is known, the host completes the packet by adding both Layer 3 (IP) and Layer 2 (MAC) headers around the data.

When the packet arrives at the destination, the receiving host checks the Layer 2 header first, discards it after verification, then checks the Layer 3 header and discards it as well.

The remaining payload is then delivered to the appropriate application for processing.

![Host to Host 3](resource:assets/learning_material/images/chapter_3/host-to-host3.gif)
*Packets are encapsulated and decapsulated across network layers*

> Each network layer adds or removes its own header information to ensure proper delivery and interpretation of data.