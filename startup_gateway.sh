#!/bin/bash

# Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# Configure interfaces
ip addr add 172.20.10.1/24 dev eth0
ip link set eth0 up

ip addr add 172.20.20.1/24 dev eth1
ip link set eth1 up

# Add NAT rule to allow traffic out (if needed for external access, though not strictly for this CTF)
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# This is the 'misconfiguration' part for the CTF.
# In a real scenario, there would be restrictive rules here.
# For this CTF, we are intentionally leaving it open to simulate a misconfiguration
# where traffic from the attacker network can reach the target network.
# No explicit iptables DROP rules are added between 172.20.10.0/24 and 172.20.20.0/24
# This allows the attacker to reach the target server.

# Start FRR (if using FRR for more complex routing, otherwise basic IP forwarding is enough)
# For this simple scenario, basic IP forwarding and interface configuration is sufficient.
# If FRR was to be used for dynamic routing protocols, more configuration would be needed.

echo "Gateway setup complete."


