# default mode
# docker will create docker0 bridge when start
# show docker0 
brctl show docker0

# create a container
docker run -d nginx
# show docker0 again
brctl show docker0

route -n