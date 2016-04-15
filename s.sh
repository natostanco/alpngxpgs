#!/bin/sh
#export NGINX_VERSION=1.9.14
#export NPS_VERSION=1.11.33.0
export LPNG_VERSION=1.2.56
export LPNG_LIB=libpng12
apk add --update sudo git apache2-dev alpine-sdk python apr-dev apr-util-dev zlib-dev linux-headers openssl-dev libjpeg-turbo-dev icu-dev gperf pcre-dev protobuf-dev protobuf-c-dev
adduser b -D
echo "b ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
sudo -E -u b -H sh -c "/home/binginx/u.sh" 
exit
