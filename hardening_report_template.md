
---

## 📄 `hardening_report_template.md`

```markdown
# 🛡️ Linux Hardening Report

Date: 3-6-2025  
Prepared by: Jagruth P.

---

## 1. Firewall Configuration (UFW)

**Default Policy:**  
- Incoming: Deny  
- Outgoing: Allow

**Allowed Ports:**  
- 22, 2222 (SSH)  
- 6000-6007 (X11)  

**Denied:**  
- Port 25 (outgoing), HTTP, specific IPs  

**Verification:**  
`sudo ufw status verbose`

---

## 2. SSH Hardening

- Root login: Disabled  
- SSH Port: Changed from 22 → 2222  
- Protocol: Forced to v2  
- MaxAuthTries: 3  

**Verification:**  
`cat /etc/ssh/sshd_config`  
`sudo systemctl restart ssh`

---

## 3. User Account Policies

- Password Length: 12+  
- Password Max Days: 90  
- Inactive Lock: After 30 days  
- Guest Login: Disabled  

**Verification:**  
`cat /etc/login.defs`  
`awk -F: '$3 >= 1000' /etc/passwd`

---

## 4. File Permissions & Ownership

| File | Permission | Owner:Group |
|------|------------|-------------|
| `/etc/shadow` | `640` | `root:shadow` |
| `/etc/passwd` | `644` | `root:root` |

- `/tmp`: Sticky bit set (1777)
- Home dirs: Set to 750
- SUID/777 Files Audited

---

## 5. Audit Logging (auditd)

**Rules Applied:**
- Monitor: `/etc/passwd`, `/etc/shadow`
- Log: `sudo` use, binary execution, login attempts

**Verification:**
- Active Rules: `sudo auditctl -l`  
- Logs: `sudo less /var/log/audit/audit.log`  
- Search by key: `sudo ausearch -k passwd_changes`

---

## Summary

The above steps enforce baseline Linux system hardening against common misconfigurations and privilege escalations. Further monitoring and patch management are recommended.

