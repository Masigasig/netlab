# Packet Transmission and Reception

### Overview

Once the destination **MAC address** is known, the host prepares the complete network packet by adding the necessary headers for both the **Network Layer (IP)** and the **Data Link Layer (MAC)**. This ensures that the data can travel through the network and reach the correct application on the destination device.

### Step 1: Packet Encapsulation (Sending Host)

* **Data** from the application layer is first segmented by the **Transport Layer** (e.g., TCP or UDP).

* The **Network Layer (Layer 3)** adds the **IP header**, including source and destination IP addresses.

* The **Data Link Layer (Layer 2)** adds the **MAC header**, specifying the source and destination MAC addresses.

* The packet is then converted into electrical, optical, or radio signals for transmission over the physical medium (Layer 1).

### Step 2: Packet Transmission

* The packet travels across the network, passing through switches, routers, or other network devices.

* Each device examines the headers relevant to its layer to forward the packet toward the destination.

### Step 3: Packet Decapsulation (Receiving Host)

* The receiving host first reads and verifies the Layer 2 (MAC) header. Once verified, the header is removed.

* Next, the Layer 3 (IP) header is checked and removed.

* Finally, the payload is delivered to the appropriate application for processing.

### Key Concept

* **Encapsulation**: Each layer adds its own header to the data for proper delivery.

* **Decapsulation**: Each layer removes its header to extract the original payload at the destination.

![Host to Host 3](resource:assets/learning_material/images/chapter_3/host-to-host3.gif)
*Packets are encapsulated and decapsulated across network layers*

> Each network layer adds or removes its own header information to ensure proper delivery and interpretation of data.