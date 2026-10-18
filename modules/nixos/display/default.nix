{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkOption
    ;
  inherit (lib.types) listOf str bool;

  cfg = config.dotfiles.display;
in {
  options.dotfiles.display = {
    enable = mkEnableOption "Display";

    gnome.enable = mkEnableOption "GNOME";
    plasma.enable = mkEnableOption "KDE Plasma";

    videoDrivers = mkOption {
      type = listOf str;
      default = [];
      description = "Video drivers to be loaded on boot.";
      example = lib.literalExpression ''["amdgpu"]'';
    };
  };

  config = mkIf cfg.enable {
    services.dbus.enable = true;

    services.displayManager = {
      defaultSession = if cfg.plasma.enable then "plasma" else "gnome";
      gdm.enable = cfg.gnome.enable;
      sddm.enable = cfg.plasma.enable;
    };

    services.desktopManager.gnome.enable = cfg.gnome.enable;
    services.desktopManager.plasma6.enable = cfg.plasma.enable;

    services.xserver = {
      inherit (cfg) enable videoDrivers;

      xkb = {
        layout = "pl";
        variant = "";
      };
    };

    hardware.nvidia.open = mkIf (lib.elem "nvidia" cfg.videoDrivers) (lib.mkDefault false);

    fonts = {
      packages = with pkgs; [
        jetbrains-mono
        roboto
        openmoji-color
        nerd-fonts.jetbrains-mono
      ];
    };

    xdg = {
      portal = {
        enable = true;

        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
        ];
      };
    };
  };
}
