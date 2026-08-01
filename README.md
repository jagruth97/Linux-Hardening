# Linux Hardening Automation Project

Modular **Bash automation suite** for baseline Linux server hardening on **Debian/Ubuntu**. Covers firewall (UFW), SSH, user account policy, file permissions, and audit logging (`auditd`) — with a rollback script for lab environments.

> **Warning:** Take a VM snapshot before running. Changing SSH port and UFW rules without a console session can lock you out of remote access.

---

## Project Structure

```
Linux-Hardening/
├── scripts/
│   ├── ufw_setup.sh           # Firewall: default deny inbound, selective allow/deny
│   ├── ssh_hardening.sh       # Disable root login, non-default port, auth limits
│   ├── user_security.sh       # Password aging, guest disable, empty-password audit
│   ├── file_permissions.sh    # Auth file perms, /tmp sticky bit, SUID/777 audit
│   ├── audit_config.sh        # auditd install & custom watch rules
│   └── revert_hardening.sh    # Rollback hardening changes (lab use)
├── hardening_report_template.md
└── README.md
```

---

## Scripts Overview

| Script | Description |
|--------|-------------|
| `ufw_setup.sh` | Enables UFW, default-deny incoming, allows SSH (22/2222), optional X11 range |
| `ssh_hardening.sh` | Disables root login, moves SSH to port 2222, sets `MaxAuthTries 3` |
| `user_security.sh` | Password length (12), max age (90 days), inactivity lock (30 days), guest disable |
| `file_permissions.sh` | Secures `/etc/passwd`, `/etc/shadow`, `/etc/gshadow`; sticky bit on `/tmp`; audits SUID/777 |
| `audit_config.sh` | Installs auditd; monitors passwd/shadow, sudo, logins, binary execution |
| `revert_hardening.sh` | Reverts UFW, SSH, login policy, file perms, and audit rules |

---

## How to Use

**Recommended order** (run with superuser privileges):

```bash
sudo bash scripts/ufw_setup.sh
sudo bash scripts/ssh_hardening.sh
sudo bash scripts/user_security.sh
sudo bash scripts/file_permissions.sh
sudo bash scripts/audit_config.sh
```

**Rollback (lab only):**

```bash
sudo bash scripts/revert_hardening.sh
```

**Verify hardening:**

```bash
sudo ufw status verbose
sudo auditctl -l
sudo ausearch -k passwd_changes
```

Use [`hardening_report_template.md`](hardening_report_template.md) to document results.

---

## Prerequisites

- Debian or Ubuntu Linux (tested on lab VMs)
- Root/sudo access
- OpenSSH server installed
- For remote admin: confirm SSH access on port **2222** before closing port 22

---

## Key Takeaways

- **Modular hardening reduces blast radius** — run and verify one domain (firewall, SSH, audit) at a time.
- **Always backup before modify** — `ssh_hardening.sh` backs up `sshd_config`; extend this pattern to all scripts.
- **Audit logging closes the loop** — hardening without monitoring leaves you blind to tampering attempts.
- **Placeholder IPs must be replaced** — UFW rules use RFC 5737 documentation IPs; customize for your environment.
- **Rollback is essential in labs** — `revert_hardening.sh` enables safe iteration and testing.

---

## Lessons Learned

1. **SSH port changes require UFW alignment** — allow the new port before disabling the old one to avoid lockout.
2. **`PASS_MIN_LEN` alone is insufficient** — modern distros need PAM (`libpam-pwquality`) for real password enforcement.
3. **Broad audit rules generate noise** — exec watches on `/bin` and `/usr/bin` are useful for demos but need tuning in production.
4. **SUID/777 audits are detect-only** — finding world-writable or SUID binaries is step one; remediation requires change management.
5. **Compliance reporting matters** — pairing automation with a verification checklist (`hardening_report_template.md`) mirrors real blue-team deliverables.

---

## Resume Value

Demonstrates defensive security automation: CIS-aligned controls, auditd deployment, SSH/UFW hardening, and compliance-style reporting — applicable to SOC, system administration, and security engineering roles.
