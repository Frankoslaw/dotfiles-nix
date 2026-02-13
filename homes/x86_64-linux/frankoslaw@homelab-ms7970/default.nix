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
    # TODO: Find alternative for caprine
    caprine-bin
    vesktop
    # whatsapp-for-linux
    wasistlos
    deja-dup
    pika-backup
    fastfetch
    ripgrep
  ];

  dotfiles.packages = {
    direnv.enable = true;
    git.enable = true;
    gtk.enable = true;
    vscode.enable = true;
  };

  dotfiles.suites = {
    dev-software.enable = true;
    dev-electronics.enable = true;
    gaming.enable = true;
    media.enable = true;
    office.enable = true;
  };

  services.flatpak.packages = [
    "com.usebottles.bottles"
    "com.github.tchx84.Flatseal"
    "org.vinegarhq.Sober"
    "io.github.flattool.Warehouse"
    "org.gnome.Firmware"
    "com.freerdp.FreeRDP"
  ];

  home.stateVersion = "25.11";
  # TODO: distrobox + gui + brew
}
