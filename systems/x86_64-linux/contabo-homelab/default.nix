{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  imports = [./hardware-configuration.nix];
  networking.hostName = "contabo-homelab";
  networking.domain = "contaboserver.net";

  dotfiles = {
    home-manager.enable = true;
    locale.enable = true;
    nix.enable = true;
    security.enable = true;
    virtualisation = {
      podman.enable = true;
    };
    zsh = {
      enable = true;
      ohMyZsh.enable = true;
    };
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  security.sudo.extraRules= [{  
    users = [ "frankoslaw" ];
    commands = [{ 
      command = "ALL" ;
      options= [ "NOPASSWD" ];
    }];
  }];

  services.openssh.enable = true;
  users.users = {
    root = {
      openssh.authorizedKeys.keys = [''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCjhSHm4kIQQ3xtadeBHK+m6VA+fbWTDwy81NwfCNDawS0fi7yi/DgsNu6F9xhlaNAK4FiTWSHp+U/gkp/RG2qcAZfjwCNOxaOm45qz+aZ1oohh4ONxp3c0vQMVgG8VUf49Q2s97NAhn7mBXG2BEGXMZQoeP3piz6IFfljc0JD36koh49Q+jcwdKDuil/Rf+etWq2d8Hz/WKAewQ2TIeosZDOGEgB2nD+H7dwS0Rl0FIG1FsV1nKsTjcamK6kS1UMHYtnud83nK9M89yrHNW/t48lT9r5P6lr68HrazZdehiqhfWXhgyzeLTgmMbT0bSxVfxpTX2Dc0E0vRovIZKm3Ro3Et3CAHTDLuhmvp3yDvJk3x940rlSzl50IYeeUoV8jPsoBzGggf5KHe2fMK9UdPB8qMCW5ezXLpY5N8Kxr+Rnh56tkjuaM6GEvHI+XPUTbKON6Qz30AahNp7Mq9K6iVq1efVAgJWxeHJq0XErW8dFGGu2RE7HURSySjAr+y1Ks= frankoslaw@fedora'' ];
    };
    
    frankoslaw = {
      openssh.authorizedKeys.keys = [''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCjhSHm4kIQQ3xtadeBHK+m6VA+fbWTDwy81NwfCNDawS0fi7yi/DgsNu6F9xhlaNAK4FiTWSHp+U/gkp/RG2qcAZfjwCNOxaOm45qz+aZ1oohh4ONxp3c0vQMVgG8VUf49Q2s97NAhn7mBXG2BEGXMZQoeP3piz6IFfljc0JD36koh49Q+jcwdKDuil/Rf+etWq2d8Hz/WKAewQ2TIeosZDOGEgB2nD+H7dwS0Rl0FIG1FsV1nKsTjcamK6kS1UMHYtnud83nK9M89yrHNW/t48lT9r5P6lr68HrazZdehiqhfWXhgyzeLTgmMbT0bSxVfxpTX2Dc0E0vRovIZKm3Ro3Et3CAHTDLuhmvp3yDvJk3x940rlSzl50IYeeUoV8jPsoBzGggf5KHe2fMK9UdPB8qMCW5ezXLpY5N8Kxr+Rnh56tkjuaM6GEvHI+XPUTbKON6Qz30AahNp7Mq9K6iVq1efVAgJWxeHJq0XErW8dFGGu2RE7HURSySjAr+y1Ks= frankoslaw@fedora'' ];
  
      isNormalUser = true;
      autoSubUidGidRange = true;
      description = "Franciszek Lopuszanski";
      extraGroups = ["wheel" "podman"];
      shell = pkgs.zsh;
    };
  };

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    nano
    git
    btop
  ];

  system.stateVersion = "24.05";
}