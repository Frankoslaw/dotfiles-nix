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
      package = pkgs-unstable.vscode-fhs;

      extensions = with pkgs-unstable.vscode-extensions; [
        # Ansible
        redhat.vscode-yaml
        zxh404.vscode-proto3

        # Cpp
        ms-vscode.cpptools
        ms-vscode.cmake-tools
        twxs.cmake

        # Science
        yzhang.markdown-all-in-one
        ms-toolsai.jupyter
        asciidoctor.asciidoctor-vscode
        marp-team.marp-vscode
        james-yu.latex-workshop

        # Rust
        tamasfe.even-better-toml
        serayuzgur.crates
        rust-lang.rust-analyzer
        
        # Nix
        bbenoist.nix
        jnoortheen.nix-ide
        arrterian.nix-env-selector

        # Python 
        ms-python.python
        ms-python.vscode-pylance

        # Style
        oderwat.indent-rainbow
        pkief.material-icon-theme

        # Other
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-containers
        svelte.svelte-vscode
        usernamehw.errorlens
        eamodio.gitlens

        gruntfuggly.todo-tree
        # icrawl.discord-vscode
        ms-vscode.hexeditor
        ritwickdey.liveserver
        streetsidesoftware.code-spell-checker
        vadimcn.vscode-lldb
        # wayou.vscode-todo-highlight
        # webfreak.debug 
        tsandall.opa
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
        "cSpell.enabled" = false;
        "dev.containers.dockerPath" = "podman";
        "lushay.OssCadSuite.path" = "/home/frankoslaw/Documents/programming/projects/fpga_fun/oss-cad-suite/bin";
      };
    };
  };
}
