# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd" "amdgpu"];
  boot.extraModulePackages = [];
  boot.supportedFilesystems = [
    "ntfs"
    "btrfs"
    "ext4"
    "ext3"
    "exfat"
    "fat32"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # es8336 patches from https://github.com/codepayne/pop-os-linux
  # boot.kernelPatches = [
  #   {
  #     name = "es8336 support";
  #     patch = "${./es8336.patch}";
  #   }
  # ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/0bcb6514-d01d-4fe5-9d77-9a6050ccf071";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/4A4A-0177";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/b80b44e5-7e4a-47d8-b5a7-96079c4268f1";}];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = true;
  hardware.xpadneo.enable = true;
}
