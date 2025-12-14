# OSI Model

### A Conceptual Framework for How Data Moves Across a Network

The **OSI Model** (Open System Interconnection) is a **conceptual framework** that explains how devices communicate over a network. It is mainly used for **teaching and troubleshooting**, helping us understand how data travels from one device to another.

> Note: In practice, the **TCP/IP model** is used for real-world networking, but the OSI model is still useful for learning and troubleshooting network concepts.

### The Seven Layers of the OSI Model

**1. Physical Layer (Layer 1)**

* Transmits raw bits (1s and 0s) as electrical signals, light, or radio waves.

* Example: sending data over **cables, fiber optics, or Wi-Fi**

**2. Data Link Layer (Layer 2)**

* Organizes bits into frames, adds **MAC addresses**, and checks for errors.

* Ensures devices on the **same local network** can communicate.

**3. Network Layer (Layer 3)**

* Uses IP addresses to identify devices and route packets across networks.

**4. Transport Layer (Layer 4)**

* Ensures data is **delivered accurately from service to service using ports**.

* TCP provides reliability, UDP provides efficiency.

**5. Session Layer (Layer 5)**

* **Manages connections between applications**, establishing, maintaining, and terminating sessions.

**6. Presentation Layer (Layer 6)**

* Handles **data formatting, encryption, and compression** so that data is readable by the receiving system.

**7. Application Layer (Layer 7)**

* The **user-facing layer**, where applications like web browsers, email clients, and file transfer programs operate.

> Today, the **Session, Presentation, and Application layers** are often combined into a single **Application layer**, but understanding them separately helps when troubleshooting network issues.

### Key Points

* OSI is a **reference model**, not implemented directly.

* It provides a **structured way to understand and troubleshoot network communication**.

* Layers are ordered **from top to bottom**: Application, Presentation, Session, Transport, Network, Data Link, Physical.