{
  inputs,
  config,
  pkgs,
  lib,
  namespace,
  secretspath,
  ...
}:
with lib;
with lib.${namespace}; {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "homelab-ms7970-nixos";
  boot.loader.timeout = 5;

  dotfiles = {
    audio.enable = true;
    boot.enable = true;
    display = {
      enable = true;
      plasma.enable = true;
      videoDrivers = ["nvidia"];
    };
    flatpak.enable = true;
    home-manager.enable = true;
    locale.enable = true;
    nix.enable = true;
    paperless = {
      enable = true;
      # Expose Paperless on the host so it can receive connections through
      # tailscale0. The VPN module trusts that interface in the firewall.
      address = "0.0.0.0";
      allowedHosts = [".ts.net"];
    };
    printing.enable = true;
    rdp = {
      enable = true;
      xrdp.enable = true;
      gnome-remote-desktop.enable = false;
    };
    security.enable = true;
    sops.enable = true;
    ssh.enable = true;
    virtualisation = {
      podman.enable = true;
      libvirtd.enable = true;
    };
    vpn.enable = true;
    wireless.enable = true;
    zsh = {
      enable = true;
      ohMyZsh.enable = true;
    };
  };

  sops.secrets.frankoslaw_passwd = {
    neededForUsers = true;
  };

  sops.secrets.tailscale_authkey = {};

  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCeiUbHvQjcHy0DeRJkxh7sO/W5BYh6+7s8Bo42j6Xp frankoslaw@bazzite''
      ];
    };

    frankoslaw = {
      openssh.authorizedKeys.keys = [
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBF33ot7xAbxecd448QL+WHJvZCR/15GVtktgX0dhXgr frano@DESKTOP-OMN418K''
      ];

      isNormalUser = true;
      autoSubUidGidRange = true;
      description = "Franciszek Lopuszanski";
      hashedPasswordFile = config.sops.secrets.frankoslaw_passwd.path;
      extraGroups = ["wheel" "networkmanager" "podman" "audio" "video" "input" "render" "libvirtd" "kvm"];
      shell = pkgs.zsh;
    };
  };

  programs.nix-ld.enable = true;
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    nano
    git
    btop
    usbutils
    pciutils
    wget
    fastfetch
    cowsay
    mangohud
    codex
    veracrypt
  ];

  system.stateVersion = "26.05";
}
