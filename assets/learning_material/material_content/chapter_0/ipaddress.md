# IP Address

### The unique identifier of a device on a network

An IP address is like a phone number or a home address for your device. It allows devices on a network to identify each other and communicate. Every host—such as a laptop, phone, smart TV, computer, or server—needs an IP address. Without one, a device cannot send or receive data.

Every data packet sent over a network contains:
* A Source IP – showing where the data came from

* A Destination IP – showing where the data is going

![IP Address](resource:assets/learning_material/images/chapter_0/ip_address.gif)
*Each packet contains a Source IP and Destination IP*

IP addresses are 32-bit numbers (binary), written as 4 parts (octets), each from 0-255.

![IP Address 2](resource:assets/learning_material/images/chapter_0/ip_address2.gif)
*Example of an IP address*

> IP addresses can be assigned hierarchically using a process called **subnetting**.

### Subnetting:

* IP addresses can be organized hierarchically using subnetting.

* A subnet mask determines which part of an IP address identifies the network and which part identifies the host.

* This helps manage large networks efficiently.