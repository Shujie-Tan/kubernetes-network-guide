# 1.7.5 2 VXLAN multicast
## 1. create vxlan multicast
## delete vxlan0 first
sudo ip link del vxlan0
sudo ip link add vxlan0 type vxlan \
    id 42 \
    dstport 4789 \
    local 192.168.1.2 \
    group 224.1.1.1 \
    dev eth0
sudo ip addr add 172.17.1.2/24 dev vxlan0
sudo ip link set vxlan0 up
