# 1.7.5 3 VXLAN + bridge
#### on host1
## 1. create vxlan0 in multicast mode
sudo ip link add vxlan0 type vxlan \
    id 42 \
    dstport 4789 \
    local 192.168.1.2 \
    group 223.1.1.1 \
    dev eth0

## 2. create bridge bridge0, bind vxlan0 to bridge0
sudo ip link add bridge0 type bridge
sudo ip link set vxlan0 master bridge0
sudo ip link set vxlan0 up
sudo ip link set bridge0 up

## 3. create network namespace and veth pair
sudo ip netns add container1

sudo ip link add veth0 type veth peer name veth1
sudo ip link set dev veth0 master bridge0
sudo ip link set dev veth0 up

sudo ip link set dev veth1 netns container1
sudo ip netns exec container1 ip link set lo up

sudo ip netns exec container1 ip link set veth1 name eth0
sudo ip netns exec container1 ip addr add 172.17.1.2/24 dev eth0
sudo ip netns exec container1 ip link set eth0 up

#### on host2, config like host1, but change ip address