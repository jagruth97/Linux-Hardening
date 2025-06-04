#!/bin/bash

echo "[*] Enforcing user security and password policies..."

# Backup login.defs
sudo cp /etc/login.defs /etc/login.defs.bak

# Set minimum password length
sudo sed -i 's/^PASS_MIN_LEN.*/PASS_MIN_LEN   12/' /etc/login.defs

# Set password aging policy in login.defs
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
sudo sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   7/' /etc/login.defs
sudo sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE   14/' /etc/login.defs

# Apply password aging and inactivity policy safely
echo "[*] Applying password aging and inactivity policy to regular users..."

for user in $(awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd); do
    shell=$(getent passwd "$user" | cut -d: -f7)

    # Skip system or non-login accounts
    if [[ "$shell" == "/usr/sbin/nologin" || "$shell" == "/bin/false" ]]; then
        echo "[-] Skipping user '$user': non-login shell."
        continue
    fi

    # Check if the password is already expired
    if sudo chage -l "$user" | grep -q "Password expired"; then
        echo "[!] Skipping user '$user': password already expired."
        continue
    fi

    # Apply aging and inactivity policy
    echo "[+] Updating policy for user '$user'..."
    sudo chage -M 90 -m 7 -W 14 -I 30 "$user"
done

# Disable guest login (LightDM)
GUEST_CONF="/etc/lightdm/lightdm.conf"
if [ -f "$GUEST_CONF" ]; then
    sudo sed -i '/^\[SeatDefaults\]/a allow-guest=false' $GUEST_CONF
else
    echo "[!] LightDM not found; skipping guest account disabling."
fi

# List regular users
echo "[+] Users with UID >= 1000:"
awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd

# Check for users with empty passwords
echo "[!] Users with empty passwords:"
sudo awk -F: '($2 == "") { print $1 }' /etc/shadow

echo "[+] User security configuration complete."
