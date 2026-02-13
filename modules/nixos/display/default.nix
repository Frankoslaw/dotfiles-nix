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
      defaultSession = "gnome";
      gdm.enable = true;
    };

    services.desktopManager.gnome.enable = true;

    services.xserver = {
      inherit (cfg) enable videoDrivers;

      xkb = {
        layout = "pl";
        variant = "";
      };
    };

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
