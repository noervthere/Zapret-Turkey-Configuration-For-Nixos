# Zapret Turkey Configuration for NixOS

> **Bypass Deep Packet Inspection (DPI) and regional blocks in Turkey on NixOS.MADE FOR PERSONAL USE, YOU MIGHT HAVE TO TROUBLESHOOT**

[![NixOS](https://img.shields.io/badge/NixOS-23.11%2B-blue?logo=nixos&logoColor=white)](https://nixos.org)

---

## ⚡ Quick Start / Installation

Run these commands in your terminal to clone and install:

### 1. Clone the repository
```bash
git clone [https://github.com/noervthere/Zapret-Turkey-Configuration-For-Nixos](https://github.com/noervthere/Zapret-Turkey-Configuration-For-Nixos)
cd Zapret-Turkey-Configuration-For-Nixos

2. Make the installer executable
Bash

chmod +x install-zapret.sh

3. Run the installer
Bash

sudo ./install-zapret.sh

🧹 Uninstallation & Reverting

Thanks to the declarative nature of NixOS, completely purging Zapret and its associated firewall rules takes only a few seconds:

    Remove the import line

    Open your main configuration file:
    Bash

    sudo nano /etc/nixos/configuration.nix

    Locate and delete ./zapret-turkey.nix from your imports list.

    Remove the configuration file
    Bash

    sudo rm /etc/nixos/zapret-turkey.nix

    Rebuild your system

    Purge active kernel modules, systemd services, and firewall overrides:
    Bash

    sudo nixos-rebuild switch

⚙️ Troubleshooting & Tuning

Network conditions and DPI setups can vary depending on your local ISP (Turk Telekom, Superonline, Kablonet, etc.) and region.

If traffic is still being blocked or dropped after installation:

    Open /etc/nixos/zapret-turkey.nix.

    Find the --dpi-desync-ttl parameter.

    Adjust its value up or down to better match your local network's hop count to the target server.

    Apply changes with sudo nixos-rebuild switch.

⚠️ Disclaimer

    [!WARNING]

    This repository and script are provided as-is for educational purposes and connectivity restoration. The maintainer is not responsible for any misuse or local policy violations.
