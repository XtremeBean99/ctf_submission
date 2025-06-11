# Challenge Document: Misconfigured Gateway

## Title

Misconfigured Gateway: The Open Secret

## Description

This Capture-the-Flag (CTF) challenge focuses on identifying and exploiting a common network misconfiguration: an overly permissive gateway. Players will navigate a simulated network environment to discover a sensitive internal service that is inadvertently exposed due to a misconfigured Access Control List (ACL) or firewall rule on a central gateway. The objective is to leverage reconnaissance techniques to pinpoint the vulnerability, access the exposed service, and ultimately retrieve the hidden flag.

This challenge is designed to highlight the critical importance of secure network segmentation and meticulous firewall management in preventing unauthorized access to internal resources. It provides a practical scenario for understanding how seemingly minor misconfigurations can lead to significant security vulnerabilities.

## Category

Network Misconfiguration, Reconnaissance

## Hints

- Sometimes, the simplest path is the most overlooked. Check your routes and rules carefully.
- What services are listening on unexpected ports?
- Is there anything publicly accessible that shouldn't be?

## Expected Flag Format

`flag{...}`


