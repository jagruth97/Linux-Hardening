#!/bin/bash

echo "[*] Starting file permission and ownership hardening..."

# Set correct ownership and permissions for sensitive system files
# /etc/passwd should be readable by all, but writable only by root
sudo chown root:root /etc/passwd
sudo chmod 644 /etc/passwd

# /etc/shadow contains password hashes – very sensitive
sudo chown root:shadow /etc/shadow
sudo chmod 640 /etc/shadow

# Group file: read for all, write by root only
sudo chown root:root /etc/group
sudo chmod 644 /etc/group

# Group shadow file: sensitive like /etc/shadow
sudo chown root:shadow /etc/gshadow
sudo chmod 640 /etc/gshadow

echo "[+] Sensitive system file permissions updated."

# Secure /tmp with sticky bit to prevent unauthorized file access
# Sticky bit ensures only the file owner can delete files in /tmp
sudo chmod 1777 /tmp
echo "[+] Sticky bit set on /tmp directory."

# Secure user home directories
echo "[*] Setting home directory permissions to 750 (owner: full, group: read-execute)..."
for dir in /home/*; do
    if [ -d "$dir" ]; then
        sudo chmod 750 "$dir"
    fi
done

# Optional security audits
#-xdev: don't search other filesystems like USB mounts or network

# (Optional) Find world-writable files
echo "[!] World-writable files (permission 777):"
sudo find / -xdev -type f -perm -0777 2>/dev/null #2>/dev/null: suppress error msg

# (Optional) Find all SUID/SGID files for audit, these can be used to escalate privileges
echo "[!] SUID/SGID files:"
sudo find / -xdev \( -perm -4000 -o -perm -2000 \) -type f 2>/dev/null

echo "[+] File permission hardening complete."
