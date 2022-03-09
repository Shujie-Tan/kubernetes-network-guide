# 1.8.2 test macvlan
# create macvlan 
sudo ip link add eth0.1 link eth0 type macvlan mode bridge

# show macvlan detail info
sudo ip -d link show eth0.1

# set up macvlan
sudo ip link set eth0.1 up

# we can set mac address of macvlan when create it
sudo ip link add eth0.1 address 56:00:00:00:00:01 type macvlan mode bridge

# delete macvlan
sudo ip link del eth0.1



# 1.8.3 macvlan communication between hosts
# create macvlan on node A
docker run -d --net="none" --name=test1 busybox

# get container id
docker inspect --format="" test1

# create macvlan
sudo ip link add eth0.1 link eth0 type macvlan mode bridge

# set eth0.1 to netns of container
sudo ip link set netns <container id> eth0.1

# enter ns and config macvlan
nsenter --target <container id> --net
ip link set eth0.1 up
ifconfig
# we will see that eth0.1 don't have ip address and gateway

ip addr add 192.168.1.12/24 dev eth0.1
ip route add default via 192.168.1.254 dev eth0.1

# now we can ping container test1 from host B, but not from host A
# macvlan only provide outer network access for container or virtual machine
ping 192.168.1.12


