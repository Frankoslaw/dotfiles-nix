# Frankoslaw's dotfiles

## Deploy config

```sh
sudo nixos-rebuild switch --flake .#
```

## Install on contabo

```sh
curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-24.05 bash -x
```

## Deploy remotely

```sh
deploy '.#homelab-contabo' --hostname contabo.local
```

## Get kube config

```sh
scp root@contabo.local:/etc/rancher/k3s/k3s.yaml ~/.kube/config
```
