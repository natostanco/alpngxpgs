#!/usr/bin/env bash
# Script for local build
sudo apt update
sudo apt install -y -q libssl-dev build-essential pcregrep
NPS_VERSION=`awk -f git-describe-remote-pgs.awk https://github.com/pagespeed/ngx_pagespeed | grep -o "[0-9][^-]*" | head -n 1`
NGINX_VERSION=`awk -f git-describe-remote-ngx.awk https://github.com/nginx/nginx | grep -o "[0-9][^-]*" | head -n 1`
wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip -O release-${NPS_VERSION}-beta.zip
unzip release-${NPS_VERSION}-beta.zip
cd ngx_pagespeed-release-${NPS_VERSION}-beta/
wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz
tar -xzvf ${NPS_VERSION}.tar.gz  # extracts to psol/
cd ..
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar -xvzf nginx-${NGINX_VERSION}.tar.gz
cd nginx-${NGINX_VERSION}/
./configure --prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx/nginx.pid --lock-path=/var/run/nginx/nginx.lock --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --http-client-body-temp-path=/var/lib/nginx/tmp/client_body --http-proxy-temp-path=/var/lib/nginx/tmp/proxy --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi --http-scgi-temp-path=/var/lib/nginx/tmp/scgi --user=nginx --group=nginx --with-ipv6 --with-pcre-jit --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-mail --with-mail_ssl_module --with-file-aio --with-http_v2_module --add-module=../ngx_pagespeed-release-${NPS_VERSION}-beta
make
cp objs/nginx ../
cd ..
rm -R ngx_pagespeed-release-${NPS_VERSION}-beta/
rm release-${NPS_VERSION}-beta.zip
rm -R nginx-${NGINX_VERSION}/
rm nginx-${NGINX_VERSION}.tar.gz
git add -A
git commit -m ngx-${NGINX_VERSION}+pgs-${NPS_VERSION}
git push
