
 

{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "22.11";
    imports = [
        # gui
        ./hyprland

        # cli
        ./git
        ./gpg
        ./direnv

        # system
        ./xdg
        ./packages
    ];
}
