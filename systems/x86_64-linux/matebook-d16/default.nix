{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  imports = [./hardware-configuration.nix];
  networking.hostName = "matebook-d16";

  dotfiles = {
    audio.enable = true;
    boot.enable = true;
    display = {
      enable = true;
      videoDrivers = ["amdgpu"];
    };
    flatpak.enable = true;
    gaming.enable = true;
    home-manager.enable = true;
    laptop.enable = true;
    locale.enable = true;
    network.enable = true;
    nix.enable = true;
    printing.enable = true;
    security.enable = true;
    virtualisation = {
      libvirtd.enable = true;
      podman.enable = true;
    };
    zsh = {
      enable = true;
      ohMyZsh.enable = true;
    };
  };

  users.users.frankoslaw = {
    isNormalUser = true;
    autoSubUidGidRange = true;
    description = "Franciszek Lopuszanski";
    extraGroups = ["networkmanager" "input" "wheel" "qemu-libvirtd" "libvirtd" "podman" "wireshark" "plugdev"];
    shell = pkgs.zsh;
  };

  programs.dconf.enable = true;
  programs.wireshark.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    nano
    git
    btop
    usbutils
    pciutils
    deploy-rs
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="f8:e4:3b:e8:f5:96", NAME="eth0"
  '';

  networking = {
    networkmanager.unmanaged = ["mac:f8:e4:3b:e8:f5:96"];

    firewall = {
      allowedTCPPorts = mkAfter [ 80 443 ];

      extraCommands = ''
        iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
        iptables -A INPUT -i eth0 -j ACCEPT
      '';
    };
  };

  networking.interfaces."eth0" = {
    useDHCP = false;
    ipv4.addresses = [{
      address = "10.0.0.1";
      prefixLength = 24;
    }];
  };
  
  system.stateVersion = "24.05";
}
