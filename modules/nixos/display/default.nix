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
  inherit (lib.types) listOf str;

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
    services.xserver = {
      inherit (cfg) enable videoDrivers;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
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
        (nerdfonts.override {fonts = ["JetBrainsMono"];})
      ];
    };

    hardware.opengl = {
      inherit (cfg) enable;

      driSupport = true;
      driSupport32Bit = true;
    };

    xdg = {
      portal = {
        inherit (cfg) enable;

        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
        ];
      };
    };

    environment.variables = rec {
      NIXOS_CONFIG = "$HOME/.config/nixos/configuration.nix";
      NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
      XDG_DATA_HOME = "$HOME/.local/share";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };
}
