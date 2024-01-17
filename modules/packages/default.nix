{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  devenv,
  ...
}:
with lib; let
  cfg = config.modules.packages;
in {
  options.modules.packages = {enable = mkEnableOption "packages";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # General
      google-chrome
      microsoft-edge
      # librewolf
      caprine-bin
      discord
      file
      anydesk
      qbittorrent

      # Windows
      pkgs-unstable.bottles
      wineWowPackages.staging
      winetricks

      # Office
      libreoffice-fresh
      endeavour
      apostrophe
      texlive.combined.scheme-full
      texmaker
      # teams
      teams-for-linux
      obsidian
      marp-cli
      mendeley

      # Games
      # grapejuice # Roblox no longer works on linux
      steam
      prismlauncher
      heroic
      protonup-ng
      protontricks
      # osu-lazer
      oppai-ng
      pkgs-unstable.r2modman

      # Anime
      anime-downloader
      nur.repos.frankoslaw.ani-cli
      anup
      adl
      filebot

      # Media
      ffmpeg-full
      mpv
      vlc
      gst_all_1.gstreamer
      gst_all_1.gst-vaapi
      gst_all_1.gst-plugins-good
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-base
      mediainfo
      pkgs-unstable.glaxnimate
      helvum
      sony-headphones-client

      # Dev
      bloomrpc
      nixpkgs-fmt
      devenv.packages.${system}.devenv
      podman
      podman-tui
      podman-compose
      pods
      pmbootstrap
      heimdall-gui
      android-udev-rules
      android-file-transfer
      jmtpfs
      go-mtpfs
      asciidoc-full
      insomnia
      dbeaver
      lsof
      jq
      rust-bin.stable.latest.default
      cloc

      # Vm + cloud
      tmux
      vagrant 
      terraform
      terraformer
      virt-viewer
      virt-manager
      gnome.gnome-boxes
      nixos-shell
      virtiofsd

      # Creative
      blender
      obs-studio
      kdenlive
      shotcut
      pitivi
      gimp
      krita
      frei0r

      # Kubernetes
      k3s
      k3sup
      kube3d
      k9s
      # kubectl
      kubergrunt
      kubectl-tree
      kubernetes-helm
      lens
      kind
      fluxctl
      argo
      kustomize
      kops
      vcluster
      distrobox
      kompose

      # Math
      # pkgs-unstable.mathematica
      graphwar
      pkgs-unstable.geogebra
      jupyter
      # python310Packages.jupyter_core

      # Tinkering
      prusa-slicer
      kicad
      freecad
    ];
  };
}
