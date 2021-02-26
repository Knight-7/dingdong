# APP: your application name

FROM golang:1.13-alpine as builder

RUN apk --no-cache add git make gcc libc-dev

WORKDIR /build

ADD . .

RUN make build

FROM alpine:3.8 as prod

ARG APP=""

# alpine image no /etc/nsswitch.conf, dns resolve order is not /etc/hosts first
# RUN echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' > /etc/nsswitch.conf

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
# RUN apk add --update ca-certificates tzdata && rm -rf /var/cache/apk/* /tmp/*
# RUN mkdir -p /etc/ssl/certs/ && update-ca-certificates --fresh

# ADD build/swagger/dist /app/swagger/dist
# ADD build/dashboard/dist /app/dashboard/dist

# ADD assets/certs /app/assets/certs

WORKDIR /application

COPY --from=0 /build/build/ .

CMD [ "ls", "-a" ]
