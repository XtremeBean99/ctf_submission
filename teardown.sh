#!/bin/bash

# Teardown script for the Misconfigured Gateway CTF

echo "Destroying Containerlab topology..."
sudo containerlab destroy --topo topology.yml --cleanup

echo "CTF environment torn down."


