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
    gaming.enable = true;
    home-manager.enable = true;
    laptop.enable = true;
    locale.enable = true;
    nix.enable = true;
    printing.enable = true;
    security.enable = true;
    sops.enable = true;
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
    extraGroups = ["input" "wheel" "qemu-libvirtd" "libvirtd" "podman" "wireshark" "plugdev"];
    shell = pkgs.zsh;
  };

  programs.dconf.enable = true;
  programs.wireshark.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    nano
    git
    btop
    usbutils
    pciutils
    wget
    neofetch
  ];

  networking.extraHosts = ''
    192.168.0.95 homelab.local
  '';
  
  system.stateVersion = "24.11";
}
