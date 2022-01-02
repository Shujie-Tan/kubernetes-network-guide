# 1. list all rules of filter table
sudo iptables -L -n
# list nat table
sudo iptables -t nat -L -n

# 2. set default policy
sudo iptables --policy INPUT DROP
# sudo iptables -P INPUT ACCEPT
sudo iptables --policy FORWARD DROP
sudo iptables --policy OUTPUT ACCEPT

# 3. set firewall rules
## 3.1 allow ssh connection
sudo iptables -A INPUT -s 10.20.30.40/24 -p tcp --dport 22 -j ACCEPT
# -A append; -s source; -p tcp means allow tcp packets; --dport 22 means allow port 22; -j ACCEPT means accept
# sudo iptables -l [chain] [number]
## 3.2 reject a subnet
sudo iptables -A INPUT -s 10.10.10.10 -j REJECT
## 3.3 reject local process connect to internet from port 1234
sudo iptables -A OUTPUT -p tcp --dport 1234 -j DROP
## 3.4 port forwording
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT\
     --to-port 8080
## 3.5 disable ping
sudo iptables -A INPUT -p icmp -j DROP
# -p icmp means match icmp packets; -j DROP means drop
## 3.6 delete a rule
# delete all
sudo iptables -F
# delete a table
sudo iptables -t nat -F
# delete a rule from a chain
sudo iptables -D INPUT -s 10.10.10.10 -j DROP
# delete empty chain
sudo iptables -X
## 3.7 self define chain
sudo iptables -N mychain

# 4. DNAT
sudo iptables -t nat -A PREROUTING -d 1.2.3.4 -p tcp --dport 80 -j DNAT \
    --to-destination 10.20.30.40:8080

# 5. SNAT
## 5.1 SNAT
sudo iptables -t nat -A POSTROUTING -s 192.168.1.2 -o eth0 \
     -j SNAT --to-source 10.172.16.1
## 5.2 MASQUERADE
sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/16 -j MASQUERADE

# 6. Save and Restore
## 6.1 save
sudo iptables-save
## 6.2 restore
sudo iptables-save > iptables.bak
sudo iptables-restore < iptables.bak