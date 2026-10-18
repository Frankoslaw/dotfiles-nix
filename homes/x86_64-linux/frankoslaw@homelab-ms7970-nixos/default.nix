{
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  programs.firefox.enable = true;
  home.packages = with pkgs; [
    kdePackages.kate
    vesktop
    deja-dup
    pika-backup
    ripgrep
  ];

  dotfiles.packages = {
    direnv.enable = true;
    git.enable = true;
    gtk = {
      enable = true;
      wallpaper = ../../../assets/wl-genshin.jpg;
    };
    vscode.enable = true;
  };

  dotfiles.suites = {
    dev-software.enable = true;
    # dev-electronics.enable = true;
    # gaming.enable = true;
    media.enable = true;
    office.enable = true;
  };

  services.flatpak.packages = [
    "com.usebottles.bottles"
    "com.github.tchx84.Flatseal"
    # "org.vinegarhq.Sober"
    "io.github.flattool.Warehouse"
    "org.gnome.Firmware"
    "com.freerdp.FreeRDP"
  ];

  home.stateVersion = "26.05";
  # TODO: distrobox + gui + brew
}
