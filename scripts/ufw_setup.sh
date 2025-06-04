#!/bin/bash

echo "[*] Enabling UFW and setting default policies..."

# Enable IPv6 support
sudo sed -i 's/IPV6=no/IPV6=yes/' /etc/default/ufw

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH and common ports
sudo ufw allow OpenSSH
sudo ufw allow 22
sudo ufw allow 2222

# Allow X11 range
sudo ufw allow 6000:6007/tcp
sudo ufw allow 6000:6007/udp

# IP-specific rules
sudo ufw allow from 203.0.113.4
sudo ufw allow from 203.0.113.4 to any port 22
sudo ufw allow from 203.0.113.0/24

# Deny rules
sudo ufw deny http
sudo ufw deny from 203.0.113.4
sudo ufw deny out 25

# Enable UFW
sudo ufw enable

echo "[+] UFW configuration complete. Current rules:"
sudo ufw status verbose
