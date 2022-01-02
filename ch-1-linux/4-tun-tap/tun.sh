ip addr add 192.128.1.2/24 dev tun0
ip link set tun0 up

ping -c 4 192.128.1.2