sudo ip link add veth0 type veth peer name veth1
sudo ip link list
sudo ip link set veth0 up
sudo ip link set veth1 up

ifconfig veth0 10.20.30.40/24

sudo ip netns add newns
ip link set veth1 netns newns
