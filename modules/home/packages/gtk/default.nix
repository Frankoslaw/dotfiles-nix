{
  config,
  pkgs,
  lib,
  inputs,
  osConfig ? {},
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types) path;
  mkTuple = inputs.home-manager.lib.hm.gvariant.mkTuple;

  cfg = config.dotfiles.packages.gtk;
  gnomeEnabled = lib.attrByPath ["dotfiles" "display" "gnome" "enable"] false osConfig;
  plasmaWallpaper = pkgs.writeShellScript "dotfiles-plasma-wallpaper" ''
    # Plasma may not have finished starting when the desktop autostart entries run.
    sleep 3
    for attempt in $(seq 1 10); do
      if ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-wallpaperimage \
        "${cfg.wallpaper}"; then
        exit 0
      fi
      sleep 1
    done

    exit 1
  '';
in {
  options.dotfiles.packages.gtk = {
    enable = mkEnableOption "gtk";

    wallpaper = mkOption {
      type = path;
      default = ../../../../assets/wl-genshin.jpg;
      description = "Wallpaper image used by GNOME and KDE Plasma.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = lib.optionals gnomeEnabled (with pkgs; [
      gnome-tweaks
      gnome-shell-extensions
      gnome-extension-manager

      gnomeExtensions.media-controls
      gnomeExtensions.caffeine
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.tiling-assistant
      gnomeExtensions.restart-to
    ]);

    gtk = {
      inherit (cfg) enable;

      # Leave existing GTK config files untouched; they may be managed outside
      # Home Manager already.
      gtk2.enable = false;
      gtk3.enable = false;
      gtk4.enable = false;

      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
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

    xdg.configFile."autostart/dotfiles-plasma-wallpaper.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Dotfiles Plasma wallpaper
      Exec=${plasmaWallpaper}
      OnlyShowIn=KDE;Plasma;
      X-GNOME-Autostart-enabled=true
    '';

    dconf.settings = {
      "system/locale" = {
        region = "pl_PL.UTF-8";
      };
    } // lib.optionalAttrs gnomeEnabled {
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
        clock-show-seconds = false;
        clock-show-weekday = true;
        show-battery-percentage = true;
      };

      "org/gnome/desktop/background" = {
        picture-uri = "file://${cfg.wallpaper}";
        picture-uri-dark = "file://${cfg.wallpaper}";
        picture-options = "zoom";
      };

      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${cfg.wallpaper}";
        picture-uri-dark = "file://${cfg.wallpaper}";
        picture-options = "zoom";
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

    };
  };
}
