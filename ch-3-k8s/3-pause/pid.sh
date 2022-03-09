# create a pause container
docker run -d --name pause gcr.io/google_containers/pause-amd64:3.0

# run a busybox container and join the pause container
docker run -itd --name busybox \
    --net=container:pause \
    --pid=container:pause \
    busybox
    # --ipc=container:pause \ # not working

#
docker exec -it <busybox-id> /bin/sh   
# run in busybox container
ps aux
# we will see the pause container

