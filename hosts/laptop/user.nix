{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {

        # cli
        # nvim.enable = true;
        # zsh.enable = true;
        # git.enable = true;
        # gpg.enable = true;
        # direnv.enable = true;

        # system
        packages.enable = true;
    };
}