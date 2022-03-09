# 1.8
## configure hairpin of bridge br0
sudo brctl hairpin br0 eth0 on
sudo ip link set dev eth0 hairpin on
## or
echo 1 > /sys/devices/virtual/net/br0/hairpin_mode
