# 1.9.2 test IPvlan
# create two network namespace
sudo ip netns add net1
sudo ip netns add net2

# create IPvlan in l3 mode
sudo ip link add ipv1 link eth0 type ipvlan mode l3
sudo ip link add ipv2 link eth0 type ipvlan mode l3

# set network namespace of ipvlan and turn up
sudo ip link set ipv1 netns net1
sudo ip link set ipv2 netns net2
sudo ip netns exec net1 ip link set ipv1 up
sudo ip netns exec net2 ip link set ipv2 up

# config ip address of ipvlan
sudo ip netns exec net1 ip addr add 10.0.1.10/24 dev ipv1
sudo ip netns exec net2 ip addr add 192.168.1.10/24 dev ipv2
sudo ip netns exec net1 ip route add default dev ipv1
sudo ip netns exec net2 ip route add default dev ipv2

# test ping
sudo ip netns exec net1 ping -c 3 192.168.1.10