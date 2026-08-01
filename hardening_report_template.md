# Linux Hardening Report

**Date:** 3-6-2025  
**Prepared by:** Jagruth P.

---

## 1. Firewall Configuration (UFW)

**Default Policy:**
- Incoming: Deny
- Outgoing: Allow

**Allowed Ports:**
- 22, 2222 (SSH)
- 6000-6007 (X11 — remove if not needed)

**Denied:**
- Port 25 (outgoing SMTP)
- HTTP (inbound, if configured)

**Verification:**
```bash
sudo ufw status verbose
```

---

## 2. SSH Hardening

| Control | Value |
|---------|-------|
| Root login | Disabled |
| SSH Port | 2222 (changed from 22) |
| MaxAuthTries | 3 |

**Verification:**
```bash
grep -E '^(Port|PermitRootLogin|MaxAuthTries)' /etc/ssh/sshd_config
sudo systemctl restart sshd
```

---

## 3. User Account Policies

| Control | Value |
|---------|-------|
| Password min length | 12 |
| Password max age | 90 days |
| Inactive account lock | 30 days |
| Guest login | Disabled |

**Verification:**
```bash
cat /etc/login.defs | grep -E 'PASS_(MIN|MAX)'
awk -F: '$3 >= 1000' /etc/passwd
```

---

## 4. File Permissions & Ownership

| File | Permission | Owner:Group |
|------|------------|-------------|
| `/etc/shadow` | `640` | `root:shadow` |
| `/etc/passwd` | `644` | `root:root` |
| `/etc/gshadow` | `640` | `root:shadow` |

- `/tmp`: Sticky bit set (`1777`)
- Home directories: `750`
- SUID/SGID and world-writable files: Audited (list in appendix)

---

## 5. Audit Logging (auditd)

**Rules Applied:**
- Monitor changes to `/etc/passwd`, `/etc/shadow`
- Log `sudo` usage, login success/failure, binary execution

**Verification:**
```bash
sudo auditctl -l
sudo less /var/log/audit/audit.log
sudo ausearch -k passwd_changes
```

---

## Summary

The above controls enforce baseline Linux hardening against common misconfigurations and privilege escalation vectors. Ongoing patch management, log review, and periodic re-audits are recommended.

**Next steps:** Tune audit rules for log volume, add fail2ban for SSH, evaluate AppArmor/SELinux profiles.
