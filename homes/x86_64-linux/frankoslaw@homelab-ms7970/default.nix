{
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  home.packages = with pkgs; [
    fastfetch
  ];

  dotfiles.packages = {
    direnv.enable = true;
    git.enable = true;
  };

  home.stateVersion = "24.11";
}