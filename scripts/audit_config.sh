#!/bin/bash

set -e  # Exit immediately on error

echo "[*] Starting auditd configuration..."

# Step 1: Install auditd if not present
if ! dpkg -s auditd &> /dev/null; then
    echo "[*] Installing auditd and plugins..."
    sudo apt update
    sudo apt install -y auditd audispd-plugins
else
    echo "[+] auditd is already installed."
fi

# Step 2: Enable and start the auditd service
echo "[*] Enabling and starting auditd..."
sudo systemctl enable auditd
sudo systemctl start auditd
echo "[+] auditd service is enabled and running."

# Step 3: Create or reset audit rules file
AUDIT_RULES="/etc/audit/rules.d/hardening.rules"
echo "[*] Creating/clearing custom audit rules file: $AUDIT_RULES"
sudo bash -c "echo '' > $AUDIT_RULES"  # Clear existing rules in this file

# Step 4: Add custom audit rules

echo "[*] Writing custom audit rules..."

# Monitor passwd and shadow files (important for tracking user changes)

# -w: watch file, -p wa: Log writes(w) & attribute(a) changes, -k: key(name to search logs easily
# tee: command that reads from standard input & writes to a file, -a: append
echo "-w /etc/passwd -p wa -k passwd_changes" | sudo tee -a $AUDIT_RULES
echo "-w /etc/shadow -p wa -k shadow_changes" | sudo tee -a $AUDIT_RULES

# Monitor usage of sudo (tracks elevation of privilege)
echo "-w /usr/bin/sudo -p x -k sudo_usage" | sudo tee -a $AUDIT_RULES

# Track login success and failures
echo "-w /var/log/faillog -p wa -k login_failures" | sudo tee -a $AUDIT_RULES
echo "-w /var/log/lastlog -p wa -k login_success" | sudo tee -a $AUDIT_RULES

# Monitor execution of binaries
echo "-w /bin -p x -k binary_exec" | sudo tee -a $AUDIT_RULES
echo "-w /usr/bin -p x -k binary_exec" | sudo tee -a $AUDIT_RULES

# Step 5: Apply the rules
echo "[*] Reloading audit rules..."
sudo augenrules --load # augenrules: AUdit GENerate RULES, reads all rule files, used for persisten audit rules
echo "[+] Custom audit rules have been loaded."

# Step 6: Display the current rules
echo "[*] Active audit rules:"
sudo auditctl -l

echo "[*] auditd setup complete. It is now monitoring key system events."
