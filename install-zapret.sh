#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run this script as root (sudo ./install-zapret.sh)"
  exit 1
fi

echo "🚀 Installing Zapret DPI Bypass for Turkey (Discord & Roblox)..."

# 1. Create the configuration file
cat << 'EOF' > /etc/nixos/zapret-turkey.nix
# =============================================================================
#  ZAPRET DPI BYPASS MODULE — TURKEY (Discord + Roblox)
#  NixOS native services.zapret configuration
# =============================================================================
#
#  Target:  Discord (client, CDN, media, voice/RTC) + Roblox (launcher,
#           auth, assets CDN, UDP game servers)
#  OS:      NixOS (nixpkgs native services.zapret module)
#
#  IMPORTANT NOTES:
#    • Turkish ISPs also perform DNS poisoning. The secure DNS settings
#      below (DoH/DoT via systemd-resolved) are MANDATORY to prevent apps 
#      like Vesktop from connecting to hijacked IPs.
#    • The `configureFirewall` option ONLY works with iptables (legacy).
# =============================================================================

{ config, pkgs, lib, ... }:

{
  # ===========================================================================
  #  1. SECURE DNS — Bypass DNS Poisoning (MANDATORY for Turkey)
  # ===========================================================================
  # Turkish ISPs hijack/poison DNS responses for blocked domains.
  # System-wide encrypted DNS via systemd-resolved (DNS-over-TLS)
  # This is REQUIRED because Vesktop and Roblox don't have built-in DoH like
  # Firefox, meaning they fall victim to the ISP's port 53 DNS interception.
  
  networking.nameservers = [
    "1.1.1.1"        # Cloudflare Primary
    "1.0.0.1"        # Cloudflare Secondary
    "8.8.8.8"        # Google Primary
    "8.8.4.4"        # Google Secondary
  ];

  networking.dhcpcd.extraConfig = ''
    nohook resolv.conf
  '';

  services.resolved = {
    enable = true;
    dnssec = "false"; # Disable DNSSEC to prevent validation issues with DoT
    dnsovertls = "true"; # STRICT mode: never fall back to unencrypted port 53
    fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
  };

  # ===========================================================================
  #  2. KERNEL MODULES — Required for NFQUEUE packet interception
  # ===========================================================================
  boot.kernelModules = [
    "nf_conntrack"
    "xt_NFQUEUE"
    "xt_connbytes"
    "xt_multiport"
  ];

  # ===========================================================================
  #  3. ZAPRET SERVICE CONFIGURATION
  # ===========================================================================
  services.zapret = {
    enable = true;

    # Automatically injects iptables NFQUEUE rules for TCP 443, TCP 80, and UDP
    configureFirewall = true;

    httpSupport = true;
    httpMode = "first";

    udpSupport = true;
    udpPorts = [
      "443"             # QUIC / HTTP/3 — Discord media, Roblox HTTPS alt
      "3478"            # STUN — WebRTC NAT traversal (Discord Voice)
      "3479"            # STUN alternate
      "3480"            # STUN/TURN alternate
      "3481"            # TURN relay
      "50000:65535"     # Ephemeral high-port range — Discord RTC + Roblox UDP
    ];

    qnum = 200;

    # =======================================================================
    #  ISP-SPECIFIC BYPASS PARAMETERS (Matches Turkcell Superonline)
    # =======================================================================
    # Based on blockcheck, `fake` with `ttl=3` works flawlessly.
    params = [
      "--dpi-desync=fake"
      "--dpi-desync-ttl=3"
      "--dpi-desync-autottl=2"
      "--dpi-desync-fooling=md5sig"
      "--dpi-desync-any-protocol"
      "--dpi-desync-repeats=6"
    ];

    # =======================================================================
    #  DOMAIN WHITELIST — Discord + Roblox (Exhaustive)
    # =======================================================================
    whitelist = [
      # DISCORD
      "discord.com" "discordapp.com" "discord.gg" "discord.gift" "discord.gifts"
      "dis.gd" "discord.co" "discord.dev" "discord.new" "discord.store" "discordmerch.com"
      "cdn.discordapp.com" "media.discordapp.net" "images-ext-1.discordapp.net" 
      "images-ext-2.discordapp.net" "discordapp.net" "discord.media" 
      "discordstatus.com" "status.discordapp.com" "status.discord.com"
      "discordsays.com" "discordactivities.com" "discord-activities.com" "discordpartygames.com"
      "gateway.discord.gg" "api.discord.com" "canary.discord.com" "ptb.discord.com"
      "dl.discordapp.net" "updates.discord.com" "dl.discord.com"
      "sentry.io" "discord.sentry.io"
      
      # ROBLOX
      "roblox.com" "www.roblox.com" "web.roblox.com" "m.roblox.com"
      "auth.roblox.com" "authsite.roblox.com" "accountinformation.roblox.com" "accountsettings.roblox.com"
      "apis.roblox.com" "api.roblox.com" "users.roblox.com" "presence.roblox.com"
      "locale.roblox.com" "ab-testing.roblox.com" "clientsettings.roblox.com" "clientsettingscdn.roblox.com"
      "setup.rbxcdn.com" "versioncompatibility.roblox.com" "realtime.roblox.com" "notifications.roblox.com"
      "games.roblox.com" "gamejoin.roblox.com" "gamepersistence.roblox.com" "ephemeralcounters.roblox.com" "metrics.roblox.com"
      "rbxcdn.com" "assetdelivery.roblox.com" "assetgame.roblox.com" "contentstore.roblox.com" "thumbnails.roblox.com" "tr.rbxcdn.com"
      "t0.rbxcdn.com" "t1.rbxcdn.com" "t2.rbxcdn.com" "t3.rbxcdn.com" "t4.rbxcdn.com" "t5.rbxcdn.com" "t6.rbxcdn.com" "t7.rbxcdn.com"
      "c0.rbxcdn.com" "c1.rbxcdn.com" "c2.rbxcdn.com" "c3.rbxcdn.com" "c4.rbxcdn.com" "c5.rbxcdn.com" "c6.rbxcdn.com" "c7.rbxcdn.com"
      "css.rbxcdn.com" "js.rbxcdn.com" "images.rbxcdn.com"
      "friends.roblox.com" "chat.roblox.com" "contacts.roblox.com" "followings.roblox.com"
      "catalog.roblox.com" "economy.roblox.com" "economycreatorstats.roblox.com" "trades.roblox.com"
      "premiumfeatures.roblox.com" "avatar.roblox.com" "inventory.roblox.com" "itemconfiguration.roblox.com"
      "develop.roblox.com" "publish.roblox.com" "groups.roblox.com" "badges.roblox.com"
      "rbxinfra.net" "rbxtrk.com" "robloxlabs.com" "simulpong.com" "rbx.com"
      "voice.roblox.com" "textfilter.roblox.com" "translations.roblox.com" "localizationtables.roblox.com"
    ];
  };
}
EOF

echo "✅ Generated /etc/nixos/zapret-turkey.nix"

# 2. Add to configuration.nix if not present
if ! grep -q "\./zapret-turkey\.nix" /etc/nixos/configuration.nix; then
  echo "⚙️ Adding module to /etc/nixos/configuration.nix..."
  sed -i '/imports =/a \      ./zapret-turkey.nix' /etc/nixos/configuration.nix
fi

# 3. Apply the changes
echo "🔨 Rebuilding NixOS (this may take a moment)..."
nixos-rebuild switch

echo "🎉 All done! DPI bypass for Discord and Roblox is installed and active."
