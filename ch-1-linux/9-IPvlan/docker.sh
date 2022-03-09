# 1.9.3 Docker IPvlan Network
# create IPvlan in l3 mode by docker
docker network create -d ipvlan \
    --subnet=192.168.30.0/24 \
    -o parent=eth0 \
    -o ipvlan_mode=l3 \
    ipvlan30

# create two container in ipvlan30 network
docker run --net=ipvlan30 -it --name ivlan_test3 --rm alpine /bin/sh
docker run --net=ipvlan30 -it --name ivlan_test4 --rm alpine /bin/sh

# in ivlan_test3 container
ping $hostname(ivlan_test4)

# create another IPvlan in another broadcast domain
docker network create -d ipvlan \
    --subnet=192.168.110.0/24 \
    -o parent=eth0 \
    -o ipvlan_mode=l3 \
    ipvlan110
# Error response from daemon: network di-5dbd64ced427 is already using parent 
# interface eth0
# if we created successfully, we can ping from ipvlan110 container 
# to ipvlan30 container