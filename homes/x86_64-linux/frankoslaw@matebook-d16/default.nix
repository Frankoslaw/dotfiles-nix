{
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  home.packages = with pkgs; [
    helvum
    powertop
    slack
    telegram-desktop
    caprine-bin
    vesktop
  ];

  dotfiles.packages = {
    direnv.enable = true;
    firefox.enable = true;
    git.enable = true;
    gtk.enable = true;
    vscode.enable = true;
  };

  dotfiles.suites = {
    dev.enable = true;
    gaming.enable = true;
    media.enable = true;
    office.enable = true;
  };

  home.stateVersion = "24.05";
}
