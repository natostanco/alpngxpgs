#!/bin/sh
cd
git clone https://github.com/natostanco/ngxpgs

#libpng setup
cd
wget https://sourceforge.net/projects/libpng/files/$LPNG_LIB/$LPNG_VERSION/libpng-$LPNG_VERSION.tar.gz
tar -zxf libpng-$LPNG_VERSION.tar.gz
cd libpng-$LPNG_VERSION
./configure --build=$CBUILD --host=$CHOST --prefix=/usr --enable-static --with-libpng-compat
make -j 4
sudo make install

#mod pgs
cd
wget https://dl.google.com/dl/linux/mod-pagespeed/tar/beta/mod-pagespeed-beta-$NPS_VERSION-r0.tar.bz2
tar -jxf mod-pagespeed-beta-$NPS_VERSION-r0.tar.bz2
cd modpagespeed-$NPS_VERSION/
./generate.sh -D use_system_libs=1 -D _GLIBCXX_USE_CXX11_ABI=0 -D use_system_icu=1
find ~/ngxpgs/*.patch | xargs git apply
cd src/
make BUILDTYPE=Release CXXFLAGS=" -I/usr/include/apr-1 -I/home/b/libpng-$LPNG_VERSION -fPIC -D_GLIBCXX_USE_CXX11_ABI=0" CFLAGS=" -I/usr/include/apr-1 -I/home/b/libpng-$LPNG_VERSION -fPIC -D_GLIBCXX_USE_CXX11_ABI=0" -j 4
cd pagespeed/automatic/

make psol BUILDTYPE=Release CXXFLAGS=" -I/usr/include/apr-1 -I/home/b/libpng-$LPNG_VERSION -fPIC -D_GLIBCXX_USE_CXX11_ABI=0" CFLAGS=" -I/usr/include/apr-1 -I/home/b/libpng-$LPNG_VERSION -fPIC -D_GLIBCXX_USE_CXX11_ABI=0" -j 4

#ngx pgs
cd
wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip -O release-${NPS_VERSION}-beta.zip
unzip release-${NPS_VERSION}-beta.zip
cd ngx_pagespeed-release-${NPS_VERSION}-beta/
mkdir -p psol
mkdir -p psol/lib/Release/linux/x64
mkdir -p psol/include/out/Release
cd
ln -s ~/modpagespeed-$NPS_VERSION/src/out/Release/obj ~/ngx_pagespeed-release-${NPS_VERSION}-beta/psol/include/out/Release/
ln -s ~/modpagespeed-$NPS_VERSION/src/net ~/ngx_pagespeed-release-${NPS_VERSION}-beta/psol/include/
ln -s ~/modpagespeed-$NPS_VERSION/src/testing ~/ngx_pagespeed-release-${NPS_VERSION}-beta/psol/include/
ln -s ~/modpagespeed-$NPS_VERSION/src/pagespeed ~/ngx_pagespeed-release-${NPS_VERSION}-beta/psol/include/
ln -s ~/modpagespeed-$NPS_VERSION/src/third_party ~/ngx_pagespeed-release-${NPS_VERSION}-beta/psol/include/
ln -s  ~/modpagespeed-$NPS_VERSION/src/tools ~/ngx_pagespeed-release-${NPS_VERSION}-beta/psol/include/
ln -s ~/modpagespeed-$NPS_VERSION/src/pagespeed/automatic/pagespeed_automatic.a ~/ngx_pagespeed-release-${NPS_VERSION}-beta/psol/lib/Release/linux/x64/pagespeed_automatic.a
cd 
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar -zxf nginx-${NGINX_VERSION}.tar.gz
cd nginx-${NGINX_VERSION}
LD_LIBRARY_PATH=/usr/lib
./configure \
--prefix=/usr/share/nginx \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/var/run/nginx/nginx.pid \
--lock-path=/var/run/nginx/nginx.lock \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--http-client-body-temp-path=/var/lib/nginx/tmp/client_body \
--http-proxy-temp-path=/var/lib/nginx/tmp/proxy \
--http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi \
--http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi \
--http-scgi-temp-path=/var/lib/nginx/tmp/scgi \
--user=nginx \
--group=nginx \
--with-ipv6 \
--with-pcre-jit \
--with-http_ssl_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_stub_status_module \
--with-http_auth_request_module \
--with-mail \
--with-mail_ssl_module \
--with-file-aio \
--with-http_v2_module \
--add-module=../ngx_pagespeed-release-${NPS_VERSION}-beta \
--with-cc-opt="-fPIC -I /usr/include/apr-1" \
--with-ld-opt="-luuid -lapr-1 -laprutil-1 -licudata -licuuc -L$pkgdir/usr/lib -lpng12 -lturbojpeg -ljpeg"
make -j 4
sudo cp objs/nginx /home/binginx/
sudo cp /usr/lib/libpng12.so.0 /home/binginx/
exit
