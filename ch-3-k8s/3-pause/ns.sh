# run shell in new namespace
unshare --pid --uts --ipc --mount -f chroot rootfs /bin/sh

# docker run pause
docker run -d --name pause gcr.io/google_containers/pause-amd64:3.0

# docker run nginx
docker run -d --name nginx \
    -v `pwd`/nginx.conf:/etc/nginx/nginx.conf:ro \
    -p 8080:80 --net=container:pause \
    --ipc=container:pause \
    --pid=container:pause \
    nginx

docker run -d --name ghost \
    --net=container:pause \
    --ipc=container:pause \
    --pid=container:pause \
    ghost