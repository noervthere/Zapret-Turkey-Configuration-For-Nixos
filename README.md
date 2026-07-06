Easy Zapret installation for nixos built to bypass turkish bans.


sudo.Bash# Clone the repository
git clone https://github.com/noervthere/Zapret-Turkey-Configuration-For-Nixos
cd Zapret-Turkey-Configuration-For-Nixos

# Make the installer script executable
chmod +x install-zapret.sh

# Run the installer as root
sudo ./install-zapret.sh
🧹 Uninstallation / RevertingBecause this script relies on NixOS's declarative nature, reversing the changes is completely straightforward:Open your /etc/nixos/configuration.nix in your preferred editor:Bashsudo nano /etc/nixos/configuration.nix
Locate and remove the line containing ./zapret-turkey.nix from your imports block.  Delete the configuration file entirely:Bashsudo rm /etc/nixos/zapret-turkey.nix
Rebuild your system to completely purge the packages, firewall overrides, and kernel modules:Bashsudo nixos-rebuild switch
⚠️ DisclaimerThis script is provided as-is for educational and connectivity restoration purposes. Network environments can vary heavily across different locations, regions, and minor regional sub-providers within Turkey. If your connection still drops, you may need to manually adjust the --dpi-desync-ttl parameter inside your generated configuration file to better match your local ISP hop count.  
