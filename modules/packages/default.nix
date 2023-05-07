{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  devenv,
  ...
}:
with lib; let
  cfg =
    config.modules.packages;
in {
  options.modules.packages = {enable = mkEnableOption "packages";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # General
      google-chrome
      librewolf
      caprine-bin
      discord
      file

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

      # Games
      grapejuice
      steam
      prismlauncher
      heroic
      protonup-ng
      protontricks
      steam
      osu-lazer
      oppai-ng

      # Anime
      anime-downloader
      pkgs-unstable.ani-cli
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

      # Vm + cloud
      tmux
      vagrant
      terraform
      terraformer
      virt-viewer
      virt-manager
      gnome.gnome-boxes

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
      kubectl
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
      docker-compose
      lazydocker
      distrobox
      kompose

      # Math
      pkgs-unstable.mathematica
      graphwar
      pkgs-unstable.geogebra
      jupyter
      python310Packages.jupyter_core
    ];
  };
}
