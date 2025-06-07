#!/bin/bash
echo "[*] Reverting hardening configurations..."

# Restore UFW defaults
sudo ufw disable
sudo ufw reset

# Restore SSH config (if previously hardened)
sudo cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config 2>/dev/null
sudo systemctl restart ssh

# Restore login policy
sudo cp /etc/login.defs.bak /etc/login.defs 2>/dev/null

# Relax file permissions
sudo chmod 644 /etc/passwd
sudo chmod 640 /etc/shadow
sudo chmod 644 /etc/group
sudo chmod 640 /etc/gshadow
sudo chmod 777 /tmp

# Remove auditd rules
sudo rm -f /etc/audit/rules.d/hardening.rules
sudo systemctl stop auditd
sudo systemctl disable auditd

echo "[+] Reversion complete. Restart system for full effect."
