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
    ./disko-config.nix 
    ./hardware-configuration.nix 
  ];

  networking.nameservers = [ "192.168.0.1" "8.8.8.8" ];
  networking.hostName = "homelab-ms7970";

  networking.interfaces."enp4s0" = {
    useDHCP = false;
  };

  networking.interfaces."enp7s0" = {
    useDHCP = false;
    ipv4.addresses = [{
      address = "192.168.0.95";
      prefixLength = 24;
    }];
  };

  networking.networkmanager.unmanaged = ["enp4s0" "enp7s0"];

  boot.loader.timeout = 0;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  dotfiles = {
    # boot.enable = true;
    display = {
      enable = true;
      videoDrivers = ["nvidia"];
      autoLogin = true;
      noSuspend = true;
    };
    home-manager.enable = true;
    locale.enable = true;
    wireless.enable = true;
    nix.enable = true;
    security.enable = true;
    sops.enable = true;
    ssh.enable = true;
    virtualisation = {
      docker.enable = true;
      podman.enable = true;
      libvirtd.enable = true;
    };
    zsh = {
      enable = true;
      ohMyZsh.enable = true;
    };
    sunshine = {
      enable = true;
      autoStart = true;
    };
    flatpak.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      libvdpau-va-gl
      mesa
      nvidia-vaapi-driver
      vaapiVdpau
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
      driversi686Linux.mesa
      pkgsi686Linux.nvidia-vaapi-driver
    ];
  };
  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  sops.secrets.frankoslaw_passwd = {
    neededForUsers = true;
  };

  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCjhSHm4kIQQ3xtadeBHK+m6VA+fbWTDwy81NwfCNDawS0fi7yi/DgsNu6F9xhlaNAK4FiTWSHp+U/gkp/RG2qcAZfjwCNOxaOm45qz+aZ1oohh4ONxp3c0vQMVgG8VUf49Q2s97NAhn7mBXG2BEGXMZQoeP3piz6IFfljc0JD36koh49Q+jcwdKDuil/Rf+etWq2d8Hz/WKAewQ2TIeosZDOGEgB2nD+H7dwS0Rl0FIG1FsV1nKsTjcamK6kS1UMHYtnud83nK9M89yrHNW/t48lT9r5P6lr68HrazZdehiqhfWXhgyzeLTgmMbT0bSxVfxpTX2Dc0E0vRovIZKm3Ro3Et3CAHTDLuhmvp3yDvJk3x940rlSzl50IYeeUoV8jPsoBzGggf5KHe2fMK9UdPB8qMCW5ezXLpY5N8Kxr+Rnh56tkjuaM6GEvHI+XPUTbKON6Qz30AahNp7Mq9K6iVq1efVAgJWxeHJq0XErW8dFGGu2RE7HURSySjAr+y1Ks= frankoslaw@fedora''
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMwP0VQjUw6KBu3bY32xjrjFefB78TorO7tzHBbiNpPk frankoslaw@fedora''
      ];
    };

    frankoslaw = {
      openssh.authorizedKeys.keys = [
        ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCjhSHm4kIQQ3xtadeBHK+m6VA+fbWTDwy81NwfCNDawS0fi7yi/DgsNu6F9xhlaNAK4FiTWSHp+U/gkp/RG2qcAZfjwCNOxaOm45qz+aZ1oohh4ONxp3c0vQMVgG8VUf49Q2s97NAhn7mBXG2BEGXMZQoeP3piz6IFfljc0JD36koh49Q+jcwdKDuil/Rf+etWq2d8Hz/WKAewQ2TIeosZDOGEgB2nD+H7dwS0Rl0FIG1FsV1nKsTjcamK6kS1UMHYtnud83nK9M89yrHNW/t48lT9r5P6lr68HrazZdehiqhfWXhgyzeLTgmMbT0bSxVfxpTX2Dc0E0vRovIZKm3Ro3Et3CAHTDLuhmvp3yDvJk3x940rlSzl50IYeeUoV8jPsoBzGggf5KHe2fMK9UdPB8qMCW5ezXLpY5N8Kxr+Rnh56tkjuaM6GEvHI+XPUTbKON6Qz30AahNp7Mq9K6iVq1efVAgJWxeHJq0XErW8dFGGu2RE7HURSySjAr+y1Ks= frankoslaw@fedora''
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMwP0VQjUw6KBu3bY32xjrjFefB78TorO7tzHBbiNpPk frankoslaw@fedora''
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
