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
    fastfetch
    libreoffice-fresh
  ];

  dotfiles.packages = {
    direnv.enable = true;
    git.enable = true;
    gtk.enable = true;
    vscode.enable = true;
  };

  dotfiles.suites = {
    dev.enable = true;
    gaming.enable = true;
  };

  services.flatpak.packages = [
    "org.prismlauncher.PrismLauncher"
    "com.usebottles.bottles"
    "me.iepure.devtoolbox"
    "com.github.tchx84.Flatseal"
  ];

  home.stateVersion = "24.11";
}