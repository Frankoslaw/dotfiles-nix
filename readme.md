# ❄️ NixOS dotfiles

*My configuration files for NixOS. Feel free to look around and copy!* 

# Special thanks to:
- [Notusknot's dotfiles](https://github.com/notusknot/dotfiles-nix)
- [JavaCafe01's dotfiles](https://github.com/JavaCafe01/frostedflakes)


## Commands to know
- Rebuild and switch the system configuration (in the config directory):
```
sudo nixos-rebuild switch --flake .#yourComputer --fast
```

## Installation

** IMPORTANT: do NOT use my laptop.nix . These files include settings that are specific to MY drives and they will mess up for you if you try to use them on your system. **

Please be warned that it may not work perfectly out of the box.
For best security, read over all the files to confirm there are no conflictions with your current system. 

Prerequisites:
- [NixOS installed and running](https://nixos.org/manual/nixos/stable/index.html#ch-installation)
- [Flakes enabled](https://nixos.wiki/wiki/flakes)
- Root access

Clone the repo and cd into it:

```bash
git clone https://github.com/Frankoslaw/dotfiles-nix ~/.config/nixos && cd ~/.config/nixos
```

First, create a hardware configuration for your system:

```bash
sudo nixos-generate-config
```

You can then copy this to a the `hosts/` directory (note: change `yourComputer` with whatever you want):

```
mkdir hosts/yourComputer
cp /etc/nixos/hardware-configuration.nix ~/.config/nixos/hosts/yourComputer/
```

You can either add or create your own output in `flake.nix`, by following this template:
```nix
nixosConfigurations = {
    # Now, defining a new system is can be done in one line
    #                                Architecture   Hostname
    laptop = mkSystem inputs.nixpkgs "x86_64-linux" "laptop";
    # ADD YOUR COMPUTER HERE! (feel free to remove mine)
    yourComputer = mkSystem inputs.nixpkgs "x86_64-linux" "yourComputer";
};
```

Next, create `hosts/yourComputer/user.nix`, a configuration file for your system for any modules you want to enable:
```nix
{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {
        # system
        packages.enable = true;
    };
}
```

Lastly, build the configuration with 

```bash
sudo nixos-rebuild switch --flake .#yourComputer
```

### TODO:

- move from sudo to doas
- add nixage for secrets
- add kubernetes configs
- add virtualization configs
- add vscode plugins
- enable zsh