
{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "22.11";
    imports = [
        # gui
        ./gtk
        ./firefox

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
