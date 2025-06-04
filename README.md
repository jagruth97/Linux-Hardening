# 🛡️ Linux Hardening Automation Project

This project automates key Linux hardening practices using a modular set of Bash scripts, targeting firewall configuration, SSH security, user account policy, file permission enforcement, and audit logging.

## 📂 Project Structure

linux-hardening-script/
├── scripts/
│ ├── ufw_setup.sh
│ ├── ssh_hardening.sh
│ ├── user_security.sh
│ ├── file_permissions.sh
│ └── audit_config.sh
├── screenshots/
│ └── (add terminal screenshots or proof-of-execution here)
├── hardening_report_template.md
└── README.md



| Script | Description |
|--------|-------------|
| `ufw_setup.sh` | Configures firewall with UFW, allowing/denying ports and IPs |
| `ssh_hardening.sh` | Disables root login, changes SSH port, enforces protocol 2 |
| `user_security.sh` | Enforces password policies, disables guest login, audits accounts |
| `file_permissions.sh` | Fixes sensitive file permissions, applies sticky bits, audits SUID/777 files |
| `audit_config.sh` | Installs and configures auditd to track key system events |

## 🚀 How to Use

Run each script with superuser privileges:

```bash
sudo bash scripts/ufw_setup.sh
sudo bash scripts/ssh_hardening.sh
sudo bash scripts/user_security.sh
sudo bash scripts/file_permissions.sh
sudo bash scripts/audit_config.sh
```