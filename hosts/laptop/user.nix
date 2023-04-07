{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {
        # gui

        # cli
        git.enable = true;
        gpg.enable = true;
        direnv.enable = true;

        # system
        xdg.enable = true;
        packages.enable = true;
    };
}
