{
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  home.packages = with pkgs; [
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

  services.flatpak.packages = [
    "org.prismlauncher.PrismLauncher"
    "com.usebottles.bottles"
    "me.iepure.devtoolbox"
    "com.github.tchx84.Flatseal"
    "org.vinegarhq.Sober"
  ];

  home.stateVersion = "24.11";
}
