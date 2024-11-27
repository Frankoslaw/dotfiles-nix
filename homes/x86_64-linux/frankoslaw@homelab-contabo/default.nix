{
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  home.packages = with pkgs; [
    neofetch
  ];

  dotfiles.packages = {
    direnv.enable = true;
    git.enable = true;
  };

  home.stateVersion = "24.05";
}
