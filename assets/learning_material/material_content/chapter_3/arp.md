# Address Resolution Protocol (ARP)

### Overview

The **Address Resolution Protocol (ARP)** enables devices to map **IP addresses to MAC addresses**, allowing proper communication on a local network.

### How ARP Works

**ARP Request:**

* The host broadcasts a request to all devices on the local network:
*“Who has this IP address?”*

**ARP Reply:**

The device with the matching IP responds with its MAC address.

Both the sender and receiver store this mapping in their **ARP caches** for faster future communication.

**Why ARP Matters**

* Without ARP, devices cannot deliver data to the correct hardware on the same network.

* ARP improves network efficiency by avoiding repeated broadcasts for known IP-MAC pairs.

![Host to Host 2](resource:assets/learning_material/images/chapter_3/host-to-host2.png)
*ARP maps IP addresses to MAC addresses through requests and replies*

> ARP is essential for translating logical IP addresses into physical MAC addresses within a local network.