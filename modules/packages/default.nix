{ pkgs, lib, config, devenv, rust-nix-test, ... }:

with lib;
let cfg = 
    config.modules.packages;
in {
    options.modules.packages = { enable = mkEnableOption "packages"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            # General
            vscode google-chrome
            caprine-bin discord file

            # Office
            libreoffice-fresh endeavour
            appflowy standardnotes
            apostrophe texlive.combined.scheme-full
            texmaker kile

            # Games
            grapejuice steam prismlauncher
            /* heroic */ protonup-ng protontricks
            steam 

            # Anime
            anime-downloader hakuneko ani-cli 
            anup adl filebot 
            ffmpeg mpv vlc

            # Dev
            python3 pypy3 bloomrpc nixpkgs-fmt
            devenv.packages.${system}.devenv
            rust-nix-test.packages.${system}.rust-nix-test
            podman podman-tui podman-compose
            pods 
            
            # Vm + cloud
            tmux vagrant terraform
            terraformer virt-viewer
            virt-manager gnome.gnome-boxes

            # Creative 
            blender obs-studio libsForQt5.kdenlive
            openshot-qt lightworks shotcut
            pitivi gimp krita

            # Kubernetes
            k3s k3sup kube3d k9s
            kubectl kubergrunt kubectl-tree
            kubernetes-helm lens kind fluxctl
            argo kustomize kops vcluster
            docker-compose lazydocker
            distrobox kompose
        ];
    };
}
