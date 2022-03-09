# 1.7.4 vxlan basic commands
## 1. create vxlan
sudo ip link add VXLAN0 type vxlan id 42 group 239.1.1.1 \
    dev eth0 dstport 4789
## 2. delete vxlan
sudo ip link del VXLAN0
## 3. show vxlan
sudo ip link show type vxlan
sudo ip -d link show VXLAN0 # -d for details
## 4. forward vxlan traffic
### create fdb
sudo bridge fdb add to 00:17:42:8a:b4:05 dst 192.19.0.2  dev VXLAN0
### delete fdb
sudo bridge fdb del to 00:17:42:8a:b4:05 dev VXLAN0
### show fdb
sudo bridge fdb show dev VXLAN0
