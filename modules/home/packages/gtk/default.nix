{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  mkTuple = inputs.home-manager.lib.hm.gvariant.mkTuple;

  cfg = config.dotfiles.packages.gtk;
in {
  options.dotfiles.packages.gtk = {
    enable = mkEnableOption "gtk";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gnome.gnome-tweaks
      gnome.gnome-shell-extensions
      gnome-extension-manager

      gnomeExtensions.media-controls
      gnomeExtensions.caffeine
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.tiling-assistant
    ];

    gtk = {
      inherit (cfg) enable;

      iconTheme = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
      };

      theme = {
        name = "Adwaita-dark";
      };

      cursorTheme = {
        name = "Adwaita";
      };

      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };

      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };

    home.sessionVariables.GTK_THEME = "Adwaita-dark";

    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        sources = [
          (mkTuple ["xkb" "pl"])
          (mkTuple ["xkb" "us"])
        ];
      };

      "org/gnome/shell" = {
        disable-user-extensions = false;

        # `gnome-extensions list` for a list
        enabled-extensions = [
          "trayIconsReloaded@selfmade.pl"
          "mediacontrols@cliffniff.github.com"
          "caffeine@patapon.info"
          "tiling-assistant@leleat-on-github"
        ];

        favorite-apps = [
          "code.desktop"
          "caprine.desktop"
          "vesktop.desktop"
          "firefox.desktop"
          "org.gnome.Nautilus.desktop"
          "org.gnome.Console.desktop"
        ];
      };

      "org/gnome/shell/extensions/user-theme" = {
        name = "";
      };

      "org/gnome/desktop/sound" = {
        theme-name = "freedesktop";
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

      "org/gnome/desktop/background" = {
        picture-uri = "file://${../../../../assets/wallpaper.png}";
        picture-uri-dark = "file://${../../../../assets/wallpaper.png}";
        picture-options = "zoom";
      };

      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${../../../../assets/wallpaper.png}";
        picture-uri-dark = "file://${../../../../assets/wallpaper.png}";
        picture-options = "zoom";
      };

      "org/gnome/desktop/interface" = {
        clock-show-seconds = false;
        clock-show-weekday = true;
        show-battery-percentage = true;
      };

      "org/gnome/desktop/session" = {
        idle-delay = "uint32 600";
      };

      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-timeout = 2700;
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        two-finger-scrolling-enabled = true;
        tap-to-click = true;
      };

      "system/locale" = {
        region = "pl_PL.UTF-8";
      };
    };
  };
}
