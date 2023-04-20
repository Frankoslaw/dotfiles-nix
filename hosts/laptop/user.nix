{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [../../modules/default.nix];
  config.modules = {
    # gui
    gtk.enable = true;
    firefox.enable = true;
    vscode.enable = true;

    # cli
    zsh.enable = true;
    git.enable = true;
    gpg.enable = true;
    direnv.enable = true;

    # system
    xdg.enable = true;
    packages.enable = true;
  };
}
