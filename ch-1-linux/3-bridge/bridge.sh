# create and setup a bridge interface
sudo ip link add name br0 type bridge
sudo ip link set br0 up

# or we can use bridge-utils
# brctl addbr br0

# 需要打开 eth3 的 promisc 模式
sudo ip link add veth3 type veth peer name veth4
sudo ip addr add 1.2.3.101/24 dev veth3
sudo ip addr add 1.2.3.102/24 dev veth4
sudo ip link set veth3 up
sudo ip link set veth4 up

sudo ip link set dev veth0 master br0
sudo brctl delif br0 veth0
sudo ip link set dev veth3 master br0

bridge link | grep br0
# or
brctl show br0

ping -c 1 -I veth3 1.2.3.102

# 1.3.2
sudo ip addr del 1.2.3.101/24 dev veth3
sudo ip addr add 1.2.3.101/24 dev br0

ping -c 1 -I br0 1.2.3.102

# promiscuous mode
ifconfig eth0 promisc
# exit promisc mode
ifconfig eth0 -promisc

