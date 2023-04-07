
 

{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "22.11";
    imports = [
        # gui

        # cli
        ./git
        ./gpg
        ./direnv

        # system
        ./xdg
        ./packages
    ];
}
