sudo modprobe ipip
lsmod | grep ipip

sudo ip netns add ns1
sudo ip netns add ns2

sudo ip link add v1 type veth peer name v1_p
sudo ip link add v2 type veth peer name v2_p

sudo ip link set v1 netns ns1
sudo ip link set v2 netns ns2

sudo ip addr add 10.10.10.1/24 dev v1_p
sudo ip link set v1_p up
sudo ip addr add 10.10.20.1/24 dev v2_p
sudo ip link set v2_p up

sudo ip netns exec ns1 ip addr add 10.10.10.2/24 dev v1
sudo ip netns exec ns1 ip link set v1 up
sudo ip netns exec ns2 ip addr add 10.10.20.2/24 dev v2
sudo ip netns exec ns2 ip link set v2 up

# v1 ping v2
sudo ip netns exec ns1 ping 10.10.20.2

# check ip_forward
cat /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv4/ip_forward
# permanent
vim /etc/sysctl.conf
# add
net.ipv4.ip_forward = 1

# check ns1's route
sudo ip netns exec ns1 route -n
# add route to 10.10.20.0/24 for ns1
sudo ip netns exec ns1 route add -net 10.10.20.0 \
    netmask 255.255.255.0 gw 10.10.10.1
# add route to 10.10.20.0/24 for ns2
sudo ip netns exec ns2 route add -net 10.10.20.0 \
    netmask 255.255.255.0 gw 10.10.20.1

# v1 ping v2 don't work again
sudo ip netns exec ns1 ping 10.10.20.2

# check ns1's iptables filter rules
sudo ip netns exec ns1 iptables -t filter -L
# check ns2's iptables filter rules
sudo ip netns exec ns2 iptables -t filter -L
# check iptables filter rules
sudo iptables -t filter -L
# change iptables filter default rules to ACCEPT
sudo iptables -P FORWARD ACCEPT

# v1 ping v2 again
sudo ip netns exec ns1 ping 10.10.20.2

# create tun1 and ipip tunnel at ns1
sudo ip netns exec ns1 ip tunnel add tun1 mode ipip \
    remote 10.10.20.2 local 10.10.10.2
sudo ip netns exec ns1 ip link set tun1 up
sudo ip netns exec ns1 ip addr add 10.10.100.10 \
    peer 10.10.200.10 dev tun1
# create tun2 and ipip tunnel at ns2
sudo ip netns exec ns2 ip tunnel add tun2 mode ipip \
    remote 10.10.10.2 local 10.10.20.2
sudo ip netns exec ns2 ip link set tun2 up
sudo ip netns exec ns2 ip addr add 10.10.200.10 \
    peer 10.10.100.10 dev tun2

# ping tun2 from ns1
sudo ip netns exec ns1 ping 10.10.200.10 -c 4

# check ns1 route
sudo ip netns exec ns1 route -n