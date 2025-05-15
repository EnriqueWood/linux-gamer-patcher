# Linux-gamer-patcher

Note: This software is free to use and comes with no warranties

## Linux Suspend/Resume Hook Runner

This project automatically installs `systemd` services that run user-defined scripts when the system **suspends** (suspend, hibernate, etc.) or **resumes** (resume, thaw).

It is designed to automate tasks such as turning off/on devices, sending notifications, or any other customizable action.

---

### Project Structure

```
.
├── enable-suspend-resume-user-script-hooks  # Main install script
└── extras
    ├── etc/systemd/system/
    │   ├── run-onresume-hooks.service          # Service to run scripts on suspend
    │   └── run-onsuspend-hooks.service         # Service to run scripts on resume
    └── usr/local/bin/
        ├── suspend/
        │   ├── 50-enable-wake-on-bluetooth.sh  # Turns on wake-on-blueooth if your adapter supports it
        │   └── 99-turn-off-tv.sh               # Example: Turn off TV on suspend
        └── resume/
            └── 99-turn-on-tv.sh                # Example: Turn on TV on resume
```

---

## Quick Installation

Run this command to install the services and example scripts:

```bash
curl -s -o /tmp/install-hooks.sh https://raw.githubusercontent.com/EnriqueWood/linux-gamer-patcher/refs/heads/main/enable-suspend-resume-user-script-hooks && \
chmod +x /tmp/install-hooks.sh && \
sudo /tmp/install-hooks.sh && \
rm /tmp/install-hooks.sh
```

This will:

- Download and install the suspend and resume `systemd` services.
- Create the folders `/usr/local/bin/suspend/` and `/usr/local/bin/resume/` if they don't exist.
- Download example scripts for each event.
- Enable the services automatically.

---

## Adding Your Own Scripts

Place your custom scripts here:

- `/usr/local/bin/suspend/` → run when the system suspends
- `/usr/local/bin/resume/` → run when the system resumes

### Example:
```bash
# /usr/local/bin/suspend/01-save-brightness.sh
#!/bin/bash
echo $(cat /sys/class/backlight/intel_backlight/brightness) > /tmp/last-brightness
```

Make sure your scripts are executable:

```bash
chmod +x /usr/local/bin/suspend/*.sh
chmod +x /usr/local/bin/resume/*.sh
```

---

## What Each Service Does

### `hook-onsuspend.service`
Runs all scripts in `/usr/local/bin/suspend/` before the system suspends.

### `hook-onresume.service`
Runs all scripts in `/usr/local/bin/resume/` right after the system resumes.

---

## Requirements

- Linux with `systemd`
- Superuser permissions (`sudo`)
- `curl` and `wget` installed

---

## Example Use Cases

This system can be used to automate tasks such as:

- Tuning on wake on bluetooth functionality (already included)
- Turning TVs off/on via webhooks
- Saving/restoring brightness or volume states
- Running quick backups before suspend
- Any custom script you need

---

## Uninstallation

```bash
sudo systemctl disable run-onresume-hooks.service
sudo systemctl disable run-onsuspend-hooks.service
sudo rm /etc/systemd/system/run-on{resume,suspend}-hooks.service
sudo rm -rf /usr/local/bin/{resume,suspend}
sudo systemctl daemon-reload
```

