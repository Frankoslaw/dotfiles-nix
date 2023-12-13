{
  inputs,
  pkgs,
  config,
  ...
}: {
  home.stateVersion = "23.11";
  imports = [
    # gui
    ./gtk
    ./firefox
    ./vscode

    # cli
    ./zsh
    ./git
    ./gpg
    ./direnv

    # system
    ./xdg
    ./packages
  ];
}
