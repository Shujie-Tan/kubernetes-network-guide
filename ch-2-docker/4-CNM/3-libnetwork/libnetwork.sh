docker network create -d overlay net1
docker run -d --name net1c1 --net net1 nginx
