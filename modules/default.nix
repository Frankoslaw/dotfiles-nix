
{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "22.11";
    imports = [
        # gui
        ./gtk

        # cli
        ./git
        ./gpg
        ./direnv

        # system
        ./xdg
        ./packages
    ];
}
