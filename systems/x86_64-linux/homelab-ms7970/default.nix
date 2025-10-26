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

  networking.hostName = "homelab-ms7970";
  boot.loader.timeout = 5;

  dotfiles = {
    audio.enable = true;
    boot.enable = true;
    display = {
      enable = true;
      videoDrivers = ["nvidia"];
    };
    flatpak.enable = true;
    gaming.enable = true;
    home-manager.enable = true;
    locale.enable = true;
    nix.enable = true;
    printing.enable = true;
    security.enable = true;
    sops.enable = true;
    ssh.enable = true;
    virtualisation = {
      docker.enable = true;
      podman.enable = true;
      libvirtd.enable = true;
    };
    wireless.enable = true;
    zsh = {
      enable = true;
      ohMyZsh.enable = true;
    };
  };

  sops.secrets.frankoslaw_passwd = {
    neededForUsers = true;
  };

  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCeiUbHvQjcHy0DeRJkxh7sO/W5BYh6+7s8Bo42j6Xp frankoslaw@bazzite''
      ];
    };

    frankoslaw = {
      openssh.authorizedKeys.keys = [
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCeiUbHvQjcHy0DeRJkxh7sO/W5BYh6+7s8Bo42j6Xp frankoslaw@bazzite''
      ];

      isNormalUser = true;
      autoSubUidGidRange = true;
      description = "Franciszek Lopuszanski";
      hashedPasswordFile = config.sops.secrets.frankoslaw_passwd.path;
      extraGroups = ["wheel" "networkmanager" "podman" "audio" "video" "input" "render" "docker" "libvirtd" "kvm"];
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
    neofetch
    cowsay
  ];

  system.stateVersion = "25.05";
}
