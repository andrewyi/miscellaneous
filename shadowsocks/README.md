# server

set Dockerfile_server to a tmp diretory

```
# build
docker build . -f Dockerfile_server -t kirklandatdocker/myshadowsocks:v1

# run
docker run -d --restart=always --name shadowsocks -p 443:443 kirklandatdocker/myshadowsocks:v1
```

# client

set Dockerfile_client to a tmp diretory

```
# build
docker build . -f Dockerfile_client -t kirklandatdocker/myshadowsockscli:v1

# run
docker run -d --restart=always --name shadowsockscli -p 1050:1050 kirklandatdocker/myshadowsockscli:v1
```
