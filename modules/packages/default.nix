{
  pkgs,
  unstable,
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

      # Office
      libreoffice-fresh
      endeavour
      appflowy
      standardnotes
      apostrophe
      texlive.combined.scheme-full
      texmaker
      kile

      # Games
      grapejuice
      steam
      prismlauncher
      heroic
      protonup-ng
      protontricks
      steam

      # Anime
      anime-downloader
      hakuneko
      ani-cli
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
      unstable.glaxnimate

      # Dev
      python3
      pypy3
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
      openshot-qt
      lightworks
      shotcut
      pitivi
      gimp
      krita
      frei0r
      davinci-resolve

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
      unstable.mathematica
      graphwar
      unstable.geogebra
      jupyter
      python310Packages.jupyter_core
    ];
  };
}
