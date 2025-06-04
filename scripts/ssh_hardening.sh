#!/bin/bash

echo "[*] Starting SSH hardening..."

SSH_CONFIG="/etc/ssh/sshd_config"

if [ ! -f "$SSH_CONFIG" ]; then
    echo "[!] SSH config file not found at $SSH_CONFIG"
    exit 1
fi

# Backup original config
sudo cp $SSH_CONFIG ${SSH_CONFIG}.bak

# Disable root login
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' $SSH_CONFIG

# Change default SSH port to 2222
sudo sed -i 's/^#Port 22/Port 2222/' $SSH_CONFIG

# Ensure Protocol 2 is used
sudo sed -i 's/^#Protocol .*/Protocol 2/' $SSH_CONFIG

# Limit max authentication tries
sudo sed -i 's/^#MaxAuthTries.*/MaxAuthTries 3/' $SSH_CONFIG

# Optional: Key-based authentication
# sudo sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' $SSH_CONFIG
# sudo sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' $SSH_CONFIG

echo "[*] Restarting SSH service..."

if systemctl list-units --type=service | grep -q sshd.service; then
    sudo systemctl restart sshd
elif systemctl list-units --type=service | grep -q ssh.service; then
    sudo systemctl restart ssh
else
    echo "[!] SSH service not found. Please restart it manually."
fi

echo "[+] SSH hardening complete. Configured to run on port 2222 with root login disabled."
