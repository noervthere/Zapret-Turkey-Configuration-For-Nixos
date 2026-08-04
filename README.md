Easy Zapret installation for nixos built to bypass turkish bans.

# Installation |
# 1-
git clone https://github.com/noervthere/Zapret-Turkey-Configuration-For-Nixos
cd Zapret-Turkey-Configuration-For-Nixos

# Make the installer script executable |
# 2- 
chmod +x install-zapret.sh

# Run the installer as root |
# 3-
sudo ./install-zapret.sh


🧹 Uninstallation / Reverting | Because this script relies on NixOS's declarative nature, reversing the changes is completely straightforward:Open your /etc/nixos/configuration.nix in your preferred editor: sudo nano /etc/nixos/configuration.nix

Locate and remove the line containing ./zapret-turkey.nix from your imports block.  Delete the configuration file entirely

Rebuild your system to completely purge the packages, firewall overrides, and kernel modules:
sudo nixos-rebuild switch

⚠️ Disclaimer This script is provided as-is for educational and connectivity restoration purposes. Network environments can vary heavily across different locations, regions, and minor regional sub-providers within Turkey. If your connection still drops, you may need to manually adjust the --dpi-desync-ttl parameter inside your generated configuration file to better match your local ISP hop count.  
