#!/bin/bash

# Setup script for the Misconfigured Gateway CTF

# Ensure Containerlab is installed (this might be pre-installed in the environment)
# if ! command -v containerlab &> /dev/null
# then
#    echo "Containerlab not found. Please install it first: https://containerlab.dev/install/"
#    exit 1
# fi

echo "Deploying Containerlab topology..."
sudo containerlab deploy -t topology.yml --reconfigure

echo "Copying startup scripts and flag file to appropriate locations..."
# Containerlab mounts the current directory into the nodes, so these files should be accessible.
# However, for clarity and robustness, we can ensure they are in the expected paths.
# The topology file already specifies binds for these, so explicit copying here might be redundant
# but serves as a good practice for ensuring files are where they need to be.

# For target-server, flag.html is bound to /usr/share/nginx/html/flag.html
# For gateway, startup_gateway.sh is bound to /etc/frr/startup_gateway.sh

echo "CTF environment deployed. You can now access the attacker-client node using:"
echo "sudo containerlab ssh --node attacker-client"


