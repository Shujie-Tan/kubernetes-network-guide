## 1. check container ip
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
    <container-name-or-id>

## 2. port mapping
docker run -d --name=<container-name> \
    -p <host-port>:<container-port> \
    <image-name>
### the -P will allocate a random port
## check iptables rules
sudo iptables -t nat -L PREROUTING
sudo iptables -t nat -L OUTPUT

docker port <container-name> <port number>

## 3. access outer network
## make sure ip_forward is enabled
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -L POSTROUTING
## 172.17.0.0/16 is the subnet of container


## 4. DNS and hostname
### DNS
### /etc/resolv.conf will be kept same with host when container is created
### /etc/hosts will write some address and name of the container
### /etc/hostname will write the hostname of the container
### docker daemon config file can set dns


## 5. self-defined network
### create network by docker
docker network create -d bridge --subnet 172.25.0.0/16 mynet
ip addr | grep <container-id-prefix>
docker inspect <container-id-prefix> # or
docker network inspect mynet
docker network rm mynet
docker network connect mynet <container-name>
docker network disconnect mynet <container-name>

## 6. Service
### create a docker network foo
docker network create -d bridge foo
### push my-service
docker service publish my-service.foo
docker service attach <container-id> my-service.foo
### example
docker run -itd --publish-service db.foo.bridge busybox # don't work
### todo: docker service tutorial

## 7. docker link
### usage
docker run -d nginx --link=<container-name-or-id>:<alias>
### example
docker run -d --name abc nginx
docker run -d --name efg --link abc:source nginx
docker exec -it efg /bin/sh
# ping abc from efg
# ping source from efg
ping -c 1 source
ping -c 1 abc
cat /etc/hosts