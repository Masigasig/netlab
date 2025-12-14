# Routing Types

### How Routes Are Created and Maintained

Routers do not automatically know every possible network. Instead, their **routing tables** are built using different types of routes, each serving a specific purpose. The two main routing types you will encounter are static routing and dynamic routing.

> Directly connected routes exist automatically, while static and dynamic routes define how routers reach remote networks.

### Directly Connected Route

* A **directly connected route** is created automatically when a router interface is connected to a network and assigned an IP address.

* The router immediately knows the network exists because it is **physically and logically** connected to it.

* No manual configuration or routing protocol is required.

### Static Route

**Static routing** uses routes that are manually configured by a network administrator.

**Key characteristics:**

* Routes remain **fixed** until they are changed or removed manually.

* Simple and predictable.

* Best suited for small, stable networks where the topology rarely changes.

**Limitation:**

* If the network changes, static routes do not update automatically, and incorrect routes can cause packet loss.

### Dynamic Route

**Dynamic routing** allows routers to automatically learn and update routes by exchanging information with other routers using routing protocols.

**Key characteristics:**

* Routes adjust automatically when network topology changes.

* Ideal for large or frequently changing networks.

* Requires more CPU, memory, and bandwidth than static routing.