{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkOption
    ;
  inherit (lib.types) listOf str;

  cfg = config.dotfiles.sops;
in {
  # TODO: Fix ability to disable sops
  imports = [inputs.sops-nix.nixosModules.sops];

  options.dotfiles.sops = {
    enable = mkEnableOption "Enable sops";
    secretsPath = mkOption {
      type = str;
      default = "${inputs.nix-secrets}/secrets.yaml";
      description = "Path to the secrets.yaml file managed by sops.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      age
      sops
      ssh-to-age
    ];

    sops = {
      defaultSopsFile = cfg.secretsPath;
      age = {
        # nix-secrets is encrypted for the user's age identity derived from
        # ~/.ssh/id_ed25519, not for the machine's SSH host key.
        sshKeyPaths = [];
        keyFile = "/home/frankoslaw/.config/sops/age/keys.txt";
        generateKey = false;
      };
    };
  };
}
