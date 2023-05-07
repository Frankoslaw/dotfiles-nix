{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.gtk;
  mkTuple = lib.hm.gvariant.mkTuple;
in {
  options.modules.gtk = {enable = mkEnableOption "gtk";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gnome.gnome-tweaks
      gnome.gnome-shell-extensions
      gnome-extension-manager

      pkgs-unstable.gnomeExtensions.pip-on-top
      pkgs-unstable.gnomeExtensions.media-controls
      gnomeExtensions.caffeine
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.color-picker
      gnomeExtensions.colorful-battery-indicator
      gnomeExtensions.tiling-assistant
    ];

    gtk = {
      enable = true;

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
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "trayIconsReloaded@selfmade.pl"
          "Vitals@CoreCoding.com"
          "dash-to-panel@jderose9.github.com"
          "sound-output-device-chooser@kgshank.net"
          "space-bar@luchrioh"
          "mediacontrols@cliffniff.github.com"
          "caffeine@patapon.info"
          "pip-on-top@rafostar.github.com"
          "trayIconsReloaded@selfmade.pl"
          "tiling-assistant@leleat-on-github"
        ];

        favorite-apps = [
          "code.desktop"
          "caprine.desktop"
          "discord.desktop"
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
        picture-uri = "file://${../../pics/wallpaper.png}";
        picture-uri-dark = "file://${../../pics/wallpaper.png}";
        picture-options = "zoom";
      };

      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${../../pics/wallpaper.png}";
        picture-uri-dark = "file://${../../pics/wallpaper.png}";
        picture-options = "zoom";
      };

      "org/gnome/desktop/interface" = {
        clock-show-seconds = true;
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
