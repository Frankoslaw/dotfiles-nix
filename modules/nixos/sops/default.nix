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
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

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
            sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
            keyFile = "/var/lib/sops-nix/key.txt";
            generateKey = true;
        };
    };
  };
}