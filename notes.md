# Homelab notes

## Ansible

```sh
ansible-playbook playbooks/01-server.yml
```

## Docker:

### Deploy container on remote host

```sh
sudo apt install python3-paramiko
export DOCKER_HOST=ssh://user@remotehost
```

## Wireguard

Generate hash:

```sh
docker run --rm -it ghcr.io/wg-easy/wg-easy wgpw 'PASS'
```

Start wireguard:

```sh
cd docker
docker-compose -f base/wg.compose.yml up -d
```

If you are running latest fedora you will also need to manually load certain kernel modules:

```sh
sudo modprobe ip_tables 
sudo modprobe iptable-nat
```

For testing you can open port:

```sh
sudo firewall-cmd --add-port 51820/tcp
sudo firewall-cmd --add-port 51821/tcp
```

```
sudo nano /etc/sysctl.conf
# At the end of file you have to add next two lines
net.ipv4.conf.all.src_valid_mark=1
net.ipv4.ip_forward=1
```

## UFW on OCI

Remember to also open the ports on OCI firewall:

```sh
sudo iptables -L
sudo iptables-save > ~/iptables-rules
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
iptables --flush

sudo apt install ufw
sudo ufw allow ssh 
sudo ufw allow 51820/udp
sudo ufw allow 51821/tcp
sudo ufw enable
sudo systemctl enable --now ufw
```

https://superuser.com/questions/1824728/how-to-proxy-requests-into-wg-easy-docker-container

```
sudo ufw allow 51820/udp
sudo ufw allow in on wg0
sudo ufw allow out on wg0
sudo ufw route allow in on wg0 out on ens3
sudo ufw route allow in on ens3 out on wg0
```

TODO:

- merge: https://github.com/Frankoslaw/cloud-native-playground
- priority eth vs wifi
- benchmark netowkr interfaces
- prevent automatic gnome start
- write ansible automation for contab, oci and raspberry pi
- merge common desktop, server and core modules
