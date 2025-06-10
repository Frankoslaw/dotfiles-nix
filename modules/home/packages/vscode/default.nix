{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.packages.vscode;
in {
  options.dotfiles.packages.vscode = {
    enable = mkEnableOption "vscode";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      inherit (cfg) enable;
      package = pkgs.vscode.fhs;

      profiles.default.extensions = with pkgs.vscode-extensions; [
        redhat.vscode-yaml

        ms-vscode.cpptools
        ms-vscode.cmake-tools
        twxs.cmake

        yzhang.markdown-all-in-one
        ms-toolsai.jupyter
        # marp-team.marp-vscode
        # james-yu.latex-workshop

        tamasfe.even-better-toml
        fill-labs.dependi
        # TODO FIX: rust-lang.rust-analyzer
        vadimcn.vscode-lldb
        # TODO: Slint.slint

        bbenoist.nix
        jnoortheen.nix-ide

        ms-python.python
        ms-python.vscode-pylance

        oderwat.indent-rainbow
        pkief.material-icon-theme

        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-containers
        usernamehw.errorlens
        eamodio.gitlens

        gruntfuggly.todo-tree
        ms-vscode.hexeditor
        ritwickdey.liveserver
      ];

      profiles.default.userSettings = {
        "explorer.compactFolders" = false;
        "workbench.iconTheme" = "material-icon-theme";
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "editor.inlayHints.fontFamily" = "'JetBrainsMonoNL Nerd Font Mono'";
        "terminal.integrated.fontFamily" = "'JetBrainsMonoNL Nerd Font Mono', monospace";
        "editor.fontFamily" = "'JetBrainsMonoNL Nerd Font Mono', 'Droid Sans Mono', 'monospace', monospace";
        "dev.containers.dockerPath" = "podman";
        "redhat.telemetry.enabled" = false;
      };
    };
  };
}
