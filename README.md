# ngxpgs
Nginx + common modules + pagespeed

## `./configure`
```
--prefix=/usr/share/nginx 
--sbin-path=/usr/sbin/nginx 
--conf-path=/etc/nginx/nginx.conf 
--pid-path=/var/run/nginx/nginx.pid 
--lock-path=/var/run/nginx/nginx.lock 
--error-log-path=/var/log/nginx/error.log 
--http-log-path=/var/log/nginx/access.log 
--http-client-body-temp-path=/var/lib/nginx/tmp/client_body 
--http-proxy-temp-path=/var/lib/nginx/tmp/proxy 
--http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi 
--http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi 
--http-scgi-temp-path=/var/lib/nginx/tmp/scgi 
--user=nginx 
--group=nginx 
--with-ipv6
--with-pcre-jit 
--with-http_ssl_module 
--with-http_realip_module 
--with-http_addition_module 
--with-http_sub_module 
--with-http_dav_module 
--with-http_flv_module 
--with-http_mp4_module 
--with-http_gunzip_module 
--with-http_gzip_static_module 
--with-http_random_index_module 
--with-http_secure_link_module 
--with-http_stub_status_module 
--with-http_auth_request_module 
--with-mail --with-mail_ssl_module 
--with-file-aio 
--with-http_v2_module 
--add-module=$HOME/ngx_pagespeed-release-${NPS_VERSION}-beta # eh...
```
