{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
with lib; let
  cfg = config.modules.vscode;
in {
  options.modules.vscode = {enable = mkEnableOption "vscode";};
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs-unstable.vscode;

      extensions = with pkgs-unstable.vscode-extensions; [
        # Ansible
        bungcip.better-toml
        redhat.vscode-yaml
        zxh404.vscode-proto3
        ms-vscode.cpptools
        yzhang.markdown-all-in-one
        ms-vscode.cmake-tools
        twxs.cmake
        tamasfe.even-better-toml
        oderwat.indent-rainbow
        ms-toolsai.jupyter
        pkief.material-icon-theme
        bbenoist.nix
        jnoortheen.nix-ide
        ms-python.python
        ms-python.vscode-pylance
        # eww yuck
        asciidoctor.asciidoctor-vscode
      ];

      userSettings = {
        "explorer.compactFolders" = false;
        "workbench.iconTheme" = "material-icon-theme";
        "[python]" = {
          "editor.formatOnType" = true;
        };
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "editor.inlayHints.fontFamily" = "'JetBrainsMonoNL Nerd Font Mono'";
        "terminal.integrated.fontFamily" = "'JetBrainsMonoNL Nerd Font Mono', monospace";
        "editor.fontFamily" = "'JetBrainsMonoNL Nerd Font Mono', 'Droid Sans Mono', 'monospace', monospace";
      };
    };
  };
}
