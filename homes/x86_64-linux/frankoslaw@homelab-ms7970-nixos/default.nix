{
  config,
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
    kdePackages.ark
    vesktop
    deja-dup
    pika-backup
    ripgrep
    unzip
    unrar
    python313
    uv
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

  dotfiles.plasma.enable = true;

  dotfiles.suites = {
    dev-software.enable = true;
    # dev-electronics.enable = true;
    gaming.enable = true;
    media.enable = true;
    office.enable = true;
  };

  services.flatpak.packages = [
    "com.usebottles.bottles"
    "org.freedesktop.Platform.VulkanLayer.gamescope//25.08"
    "org.freedesktop.Platform.VulkanLayer.lsfgvk//25.08"
    "org.freedesktop.Platform.VulkanLayer.vkBasalt//25.08"
    "com.github.tchx84.Flatseal"
    # "org.vinegarhq.Sober"
    "io.github.flattool.Warehouse"
    "org.gnome.Firmware"
    "com.freerdp.FreeRDP"
  ];

  services.flatpak.overrides."com.usebottles.bottles".Context.filesystems = [
    "${config.home.homeDirectory}/.steam:rw"
    "${config.home.homeDirectory}/.local/share/Steam:rw"
  ];

  home.stateVersion = "26.05";
  # TODO: distrobox + gui + brew
}
