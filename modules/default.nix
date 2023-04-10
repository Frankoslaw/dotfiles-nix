
{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "22.11";
    imports = [
        # gui
        ./gtk

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
