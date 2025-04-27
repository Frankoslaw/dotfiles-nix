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

    autoLogin = mkOption {
      type = bool;
      default = false;
      description = "Enable auto login";
    };
    noSuspend = mkOption {
      type = bool;
      default = false;
      description = "Disable auto suspend";
    };
  };

  config = mkIf cfg.enable {
    services.dbus.enable = true;

    services.displayManager = {
      defaultSession = "gnome";

      autoLogin = mkIf cfg.autoLogin {
        enable = true;
        user = "frankoslaw";
      };
    };

    services.xserver = {
      inherit (cfg) enable videoDrivers;

      displayManager.gdm = {
        enable = true;
        autoSuspend = mkIf cfg.noSuspend false;
      };
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

    xdg = {
      portal = {
        enable = true;

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

    systemd.targets = mkIf cfg.noSuspend {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };
}
