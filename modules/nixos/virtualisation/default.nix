{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.virtualisation;
in {
  options.dotfiles.virtualisation = {
    podman.enable = mkEnableOption "Podman";
    libvirtd.enable = mkEnableOption "libvirtd";
  };

  config = {
    virtualisation = {
      libvirtd = {
        inherit (cfg.libvirtd) enable;

        qemu = {
          package = pkgs.qemu_kvm;
          vhostUserPackages = with pkgs; [ virtiofsd ];

          ovmf = {
            enable = true;
          };
        };
      };
      spiceUSBRedirection = {
        inherit (cfg.libvirtd) enable;
      };

      podman = mkIf cfg.podman.enable {
        inherit (cfg.podman) enable;

        defaultNetwork.settings.dns_enabled = true;
        dockerSocket = {
          inherit (cfg.podman) enable;
        };
      };
    };
  };
}
