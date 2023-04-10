{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.zsh;

in {
    options.modules.zsh = { enable = mkEnableOption "zsh"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [ 
            starship
        ];

        programs.zsh = {
            enable = true;
            enableAutosuggestions = true;
            enableCompletion = true;

            initExtra = ''
                eval "$(starship init zsh)"
            '';

            oh-my-zsh = {
                enable = true;
                # theme = "agnoster";

                plugins = [
                    "aws"
                    "docker"
                    "encode64"
                    "git"
                    "git-extras"
                    "man"
                    "nmap"
                    "ssh-agent"
                    "sudo"
                    "systemd"
                    "tig"
                    "tmux"
                    "vi-mode"
                    "yarn"
                    "zsh-navigation-tools"
                ];
            };
        };

        home.file.".config/starship.toml".source = ./starship.toml;
    };
}