
 

{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "22.11";
    imports = [
        # cli
        # ./nvim
        # ./zsh
        # ./git
        # ./gpg
        # ./direnv

        # system
        ./packages
    ];
}