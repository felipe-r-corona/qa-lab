# systemd Services for QA Lab

This folder contains modular `systemd` service and timer units used to orchestrate background tasks across the QA lab VMs. Each unit is designed for auditability, privilege hygiene, and resilience.

---

## Included Units

| Unit File              | Purpose                                      | Target VM     |
|------------------------|----------------------------------------------|---------------|
| `push-ddns.service`    | Triggers secure DDNS update via shell script | GitHub VM     |
| `push-ddns.timer`      | Schedules periodic execution of DDNS updates | GitHub VM     |
| `dns-updater.service`  | Runs Python-based DNS update listener        | DNS VM        |

---

## Usage

### Enable and Start a Service

```bash
sudo systemctl enable push-ddns.service
sudo systemctl start push-ddns.service

### Check status and logs
systemctl status push-ddns.service
journalctl -u push-ddns.service

### Timer Activation
sudo systemctl enable push-ddns.timer
sudo systemctl start push-ddns.timer

### Notes
Privilege Boundaries
• All services run under non-root users with scoped permissions.
• uses  only for IP resolution and hostname mapping.
• binds to local interfaces and logs updates without elevated access.

### Logging
Logs are captured via journalctl and optionally redirected to:
- /var/log/qa-lab/push-ddns.log
- /var/log/qa-lab/dns-updater.log
Ensure log rotation is configured for long-term hygiene

### Reload and launch
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable dns-updater
sudo systemctl start dns-updater


