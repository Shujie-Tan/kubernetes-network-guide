# 1.7.7
# 1. 
sudo ip link add vxlan0 type vxlan \
    id 42 \
    dstport 4789 \
    dev eth0

# maintain bridge fdb
sudo bridge fdb append 00:00:00:00:00:00 dev vxlan0 dst 192.168.8.101
sudo bridge fdb append 00:00:00:00:00:00 dev vxlan0 dst 192.168.8.102

# 2. manually add fdb entry
## create vxlan0 with nolearning
sudo ip link add vxlan0 type vxlan \
    id 42 \
    dstport 4789 \
    dev enp0s8 \
    nolearning

## still need default fdb (00:00:00:00:00:00)
sudo bridge fdb append 00:00:00:00:00:00 dev vxlan0 dst 192.168.8.101
sudo bridge fdb append 00:00:00:00:00:00 dev vxlan0 dst 192.168.8.102
sudo bridge fdb append 52:5e:55:58:9a:ab dev vxlan0 dst 192.168.8.101
# etc


# 3. proxy: turn on arp
sudo ip link add vxlan0 type vxlan \
    id 42 \
    dstport 4789 \
    dev enp0s8 \
    nolearning \
    proxy
## add ip mac mapping
sudo ip neigh add 10.20.1.3 lladdr d6:d9:cd:00:00:00 dev vxlan0

# 4. dynamic
sudo ip link add vxlan0 type vxlan \
    id 42 \
    dstport 4789 \
    dev enp0s8 \
    nolearning \
    proxy \
    l2miss \
    l3miss \
# l2miss: if no mac
# l3miss: if no ip


sudo ip monitor all dev vxlan0
# when l2miss, add arp entry
sudo ip neigh replace 10.20.1.3 \
    lladdr d6:d9:cd:00:00:00 \
    dev vxlan0 \
    nud reachable
## nud(neighbour unreachable detection)
## nud reachable: if timeout, delete automatically
# when l3miss, add fdb entry
sudo bridge fdb add ee:00:00:00:00:00 dev vxlan0 dst 192.168.8.101