# Bridge

### Bridge

A bridge is like a repeater, but with the added ability to **filter traffic**
by reading the MAC addresses of the source and destination.

It is often used to **interconnect two LANs** that operate on the same protocol.
Each port on a bridge is typically connected to a different segment, and the bridge learns which hosts are on which segment.

![Bridge](resource:assets/learning_material/images/chapter_2/bridge.gif)
*A bridge connects two network segments and filters traffic*

> Unlike hubs, bridges can filter traffic based on MAC addresses.