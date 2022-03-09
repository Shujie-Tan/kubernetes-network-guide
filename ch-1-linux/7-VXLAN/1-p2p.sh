# 1.7.5 VXLAN point to point
## on host1
## 1. create vxlan0 
sudo ip link add vxlan0 type vxlan \
    id 44 \
    dstport 4789 \
    remote 192.168.1.3 \
    dev eth0
    # or local 192.168.1.2 \
## 2. show vxlan
sudo ip -d link show vxlan0
## 3. allocate ip for vxlan0
sudo ip addr add 172.17.1.2/24 dev vxlan0
sudo ip link set vxlan0 up
sudo ip route | grep 172.17.1.0

## on host 2
## 4. create vxlan0 
### keep vni = 44, dstport = 4789
### remote = 192.168.1.2 (the ip of vxlan0's peer)
sudo ip link add vxlan0 type vxlan \
    id 44 \
    dstport 4789 \
    remote 192.168.1.2 \
    dev eth0
sudo ip addr add 172.17.1.3/24 dev vxlan0
sudo ip link set vxlan0 up

## on host 1
## 5. ping
sudo ping -c 3 172.17.1.3