# Preparing to Send Data

### Overview

Before sending data over a network, a **host must package and address the data properly** so it can reach the intended destination reliably. This involves both logical addressing (IP) and physical addressing (MAC).

### Step 1: Construct the IP Header (Layer 3)

* The host first creates an IP header, which includes:

    * **Source IP address** – identifies the sending host.

    * **Destination IP address** – identifies the receiving host.

* This ensures end-to-end delivery across networks.

* IP addresses allow the host to locate devices beyond the local network, but they cannot directly interact with hardware on the physical network.

### Step 2: Add Data Link Layer Information (Layer 2)

* To send data on the local network, the host needs the MAC address of the destination device.

* The MAC address ensures that the data is delivered to the correct physical device within the local network.

* The host uses ARP (Address Resolution Protocol) to map the destination IP to its corresponding MAC address if it’s not already cached.

### Why Both Addresses Are Needed

|Address Type | Layer | Purpose |
|-------------|------------|-------------|
|IP Address   | Layer 3 (Network Layer) | Logical addressing for end-to-end delivery across networks|
|MAC Address  | Layer 2 (Data Link)     | Physical delivery on the local network segment|

> * The host first **encapsulates data** with IP information for network-level routing.
> * Then, it adds **MAC information** for delivery on the local network.
> * This combination ensures that packets reach the correct device efficiently, both locally and across networks.

![Host to Host 1](resource:assets/learning_material/images/chapter_3/host-to-host1.png)
*IP and MAC addresses work together to deliver data*

> IP handles logical addressing (Layer 3), while MAC handles physical delivery (Layer 2).