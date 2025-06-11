# Evidence Guide: Misconfigured Gateway CTF

## Title Slide

**Student Name:** Ahmed
**Challenge Focus:** Network Misconfiguration and Reconnaissance

## Introduction

This evidence guide documents the design, implementation, and reflection on the "Misconfigured Gateway" Capture-the-Flag (CTF) challenge. It addresses key aspects of the project, from the evolution of its architecture to its educational value and the tools employed during its development. This project aimed to create a practical learning experience for understanding network security vulnerabilities.

## Question 1: Deployment Strategy and System Architecture Evolution

### Initial Design

My initial thought process for the CTF challenge revolved around a simple client-server model with a clear, but subtle, misconfiguration. The core idea was to have a target service that should be isolated but becomes accessible due to an oversight in network segmentation. I envisioned a basic setup: an attacker machine, a vulnerable server, and a gateway in between. The gateway would be the focal point of the misconfiguration.

Early on, I considered using virtual machines (VMs) for each component to simulate a more traditional network environment. However, given the time constraints and the desire for a lightweight, reproducible setup, I quickly pivoted to Containerlab. Containerlab offered the advantage of defining network topologies using a simple YAML file, allowing for rapid deployment and teardown of network labs with Docker containers acting as network nodes. This decision significantly streamlined the development process and aligned with the project's emphasis on modern networking tools.

### Evolution to Final Implementation

The architecture evolved from a conceptual idea of a misconfigured firewall to a concrete Containerlab topology. The `topology.yml` file became the central artifact, defining the `gateway`, `target-server`, and `attacker-client` nodes. The choice of `frrouting/frr` for the gateway and `nginx` for the target server was driven by their lightweight nature and ease of configuration within a containerized environment. The `alpine/git` image for the attacker client provided a minimal environment with essential networking tools like `curl` and `nmap`.

One significant refinement was the decision to simulate the misconfiguration through the absence of restrictive rules rather than the presence of an explicit 


misconfiguration. This means the challenge lies in identifying what *isn't* there (a proper firewall rule) rather than what *is* there (an incorrect rule). This subtle distinction makes the challenge more realistic, as real-world misconfigurations often stem from omissions or default-open policies.

### Cloud-Specific Constraints or Opportunities

While Containerlab runs locally, it simulates a cloud-like environment by leveraging containerization. This presented both constraints and opportunities:

-   **Constraints:** Resource limitations (CPU, RAM) of the local machine dictated the simplicity of the topology. Complex routing protocols or a large number of nodes would have been impractical. This led to focusing on a single, clear misconfiguration rather than a sprawling, multi-layered one.

-   **Opportunities:** The ephemeral nature of containers allowed for rapid iteration and testing. Deploying and destroying the lab took seconds, which was invaluable for debugging the `topology.yml` and `startup_gateway.sh` scripts. This agility is a direct benefit of containerization, mirroring the rapid deployment capabilities in cloud environments. The use of `binds` in Containerlab to mount local files (like `startup_gateway.sh` and `flag.html`) directly into the containers simplified configuration management and made the challenge self-contained and easily deployable.

## Question 2: Realistic Use (or Misuse) of Cloud Infrastructure

### Security and Service Exposure

This CTF challenge demonstrates a realistic misuse of cloud infrastructure, specifically concerning network security and service exposure. In a cloud environment, network segmentation is often achieved through Virtual Private Clouds (VPCs), security groups, and network ACLs. A common misstep is to configure these controls too broadly, inadvertently exposing internal services to unauthorized access.

In this challenge, the `gateway` node, acting as a router/firewall, is intentionally misconfigured to allow traffic from the `attacker-client` network (172.20.10.0/24) to the `target-server` network (172.20.20.0/24) without proper filtering. This simulates a scenario where a security group or network ACL in a cloud environment might have an 


"allow all" rule or an overly permissive ingress rule. This exposes the `target-server`'s Nginx web service, which hosts the flag, to the attacker. This is a realistic scenario, as developers or administrators might inadvertently leave open ports or misconfigure firewall rules during development or deployment, leading to critical vulnerabilities.

### Scalability and Isolation

While this specific CTF doesn't delve deeply into scalability, the use of Containerlab and Docker containers inherently touches upon cloud scalability principles. Each node is a container, which can be easily scaled up or down in a real cloud environment. The isolation provided by containers ensures that the misconfiguration on the gateway primarily affects the intended network segments, demonstrating how even in a misconfigured state, the underlying containerization provides a degree of isolation compared to a monolithic system.

## Question 3: Educational Value and Real-World Connections

### Core Concept: Insecure Network Segmentation

The primary educational objective of this CTF is to highlight the dangers of insecure network segmentation and misconfigured network devices. Learners are meant to discover that even a seemingly small oversight in firewall rules or ACLs can expose critical services. This directly connects to real-world cloud computing practices where misconfigured security groups, network ACLs, or routing tables are common causes of data breaches and unauthorized access.

### Real-World Incidents and Vulnerabilities

Numerous real-world incidents have stemmed from network misconfigurations. For instance, many cloud breaches have involved publicly accessible S3 buckets or misconfigured load balancers exposing internal services. While not a direct CVE, the principle of an overly permissive network device leading to exposure is a fundamental vulnerability. This challenge mirrors scenarios where:

-   **Default-open policies:** Cloud providers often have default security group rules that are too permissive, requiring explicit lockdown.
-   **Developer oversight:** During development or testing, developers might open ports for debugging and forget to close them before production deployment.
-   **Complex network architectures:** In large, complex cloud deployments, it's easy to overlook a single rule that creates an unintended path.

### Comparison to Known Architectures

This challenge can be compared to real-world scenarios involving:

-   **Misconfigured Security Groups/Network ACLs in AWS/Azure/GCP:** The `gateway` in our CTF acts similarly to a misconfigured security group that allows traffic from an untrusted source to a sensitive internal resource.
-   **Insecure Load Balancer Configurations:** Sometimes, load balancers are configured to expose backend services that should only be accessible internally.

## Question 4: Technologies, Strategies, and Tools

### Tooling Overview

-   **Containerlab:** The primary tool used for building and orchestrating the network topology. Its declarative YAML syntax made it easy to define nodes, links, and initial configurations.
-   **Docker:** Underpins Containerlab, providing the containerization for each network node (gateway, target-server, attacker-client).
-   **Nginx:** Used as the web server on the `target-server` to host the flag file. It's a lightweight and widely used web server, making it a realistic choice.
-   **FRRouting (FRR):** While not extensively configured for complex routing protocols in this simple CTF, the `frrouting/frr` image was chosen for the `gateway` node to provide a realistic Linux-based router environment. Its presence allows for future expansion into more advanced routing challenges.
-   **`iproute2`, `curl`, `nmap`:** These are standard Linux networking utilities pre-installed or easily installable on the `attacker-client` and `target-server` nodes, essential for reconnaissance and exploitation.

### Integration and Management Strategy

The strategy for integrating and managing this multi-container system was straightforward:

1.  **Declarative Topology:** The `topology.yml` file served as the single source of truth for the network layout, ensuring consistency and reproducibility.
2.  **Startup Scripts:** Custom `startup_gateway.sh` script was used to configure the gateway node with IP forwarding and interface addresses. This kept the node configuration within the Containerlab ecosystem.
3.  **File Mounting:** Containerlab's `binds` feature was crucial for mounting the `startup_gateway.sh` and `flag.html` files directly into the respective containers, simplifying file distribution and ensuring the challenge assets were in place upon deployment.

### Testing and Verification

System behavior was tested and verified through a manual process, simulating the attacker's actions:

1.  **Deployment:** The `setup.sh` script was executed to deploy the Containerlab topology.
2.  **Connectivity Check:** From the `attacker-client` node (accessed via `sudo containerlab ssh --node attacker-client`), basic `ping` commands were used to verify network connectivity to the `gateway` and `target-server`.
3.  **Port Scanning:** `nmap` was used from the `attacker-client` to scan the `target-server` for open ports, confirming that port 80 (Nginx) was indeed accessible.
4.  **Web Service Access:** `curl` was used from the `attacker-client` to access the Nginx web server on the `target-server` and retrieve the `flag.html` file, verifying the misconfiguration and the presence of the flag.
5.  **Teardown:** The `teardown.sh` script was executed to cleanly remove all Containerlab resources, ensuring a clean slate for subsequent testing.

This iterative process of deploy, test, and teardown allowed for quick identification and resolution of configuration issues, ensuring the CTF functioned as intended.

## Question 5: Time Management, Workflow, and Reflection

### Time Management and Workflow

My workflow for this project was largely iterative and driven by the need for a functional and simple solution given the tight deadline. I started by breaking down the assignment into core deliverables: topology, scripts, and documentation. I prioritized the Containerlab topology and associated scripts first, as these formed the functional core of the CTF.

I utilized a mental checklist, focusing on one component at a time. For instance, I first focused on getting the basic Containerlab topology up and running, then added the startup scripts for node configuration, and finally integrated the flag.html. This modular approach allowed for incremental progress and easier debugging.

### Reflection on Contribution as an Educational Designer

As an educational designer for this CTF, my primary contribution was to distill a complex networking concept (misconfiguration leading to exposure) into a simple, actionable, and reproducible challenge. The goal was to create a 


learning experience that was both challenging and achievable for students with foundational networking knowledge.

However, I must acknowledge a significant setback during this project. Due to unforeseen circumstances and a lack of proper initial planning, I lost a considerable amount of progress on a previous attempt at this final project. This led to a complete restart, which was incredibly demotivating and, frankly, made me consider giving up entirely. The pressure of the deadline, coupled with the need to re-do work, was a major challenge. This experience underscored the critical importance of robust version control, regular backups, and a well-defined project plan from the outset. It also highlighted the mental fortitude required to push through such obstacles. Ultimately, this project became a testament to restarting and delivering a functional, albeit simpler, solution under duress. While the final product is functional and meets the core requirements, it is simpler than my initial ambitious vision, a direct consequence of the need to restart and prioritize functionality over extensive features due to the lost time.

This personal experience, though challenging, has reinforced the educational value of practical, hands-on assignments. It taught me not only about network misconfigurations but also about project management, resilience, and the importance of adapting to unexpected difficulties. The simplified nature of this challenge, born from necessity, might even make it more accessible to a wider range of learners, proving that sometimes, less is indeed more when it comes to effective education.


