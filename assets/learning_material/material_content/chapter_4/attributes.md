# Subnet Attributes

### Subnet Attributes

Each subnet has specific attributes that define its size, range, and usable IP addresses.
Understanding these attributes helps network administrators design and manage networks more efficiently.

These values tell us which IPs can be assigned to devices, which are reserved for the network itself, and which are used for broadcasting.
Knowing how to identify and calculate these attributes is essential when dividing or configuring networks.

* Number of IP Addresses – Total number of IP addresses within the subnet.

* CIDR Notation & Subnet Mask – Defines the subnet size using prefix length (e.g., /25) and dotted-decimal form (255.255.255.128).

* Network ID – The first address that identifies the subnet itself (not assignable to a host).

* Broadcast IP – The last address in the subnet, used to send data to all hosts in that subnet.

* First Host IP – The first usable IP address available for devices.

* Last Host IP – The last usable IP before the broadcast address.

* Next Network – The starting network ID of the following subnet.

> Each subnet attribute plays a role in defining network structure.
Understanding how to calculate them ensures accurate network planning and efficient IP allocation.