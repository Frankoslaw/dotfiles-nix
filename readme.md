# Frankoslaw's dotfiles

## Deploy config

```sh
sudo nixos-rebuild switch --flake .#
```

## Install on contabo

```sh
curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-24.05 bash -x
```

## Deploy remotly

```sh
deploy '.#contabo-homelab' --hostname contabo.local
```
