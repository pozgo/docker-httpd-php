FROM polinux/httpd:centos

ENV \
    NVM_DIR="/usr/local/nvm" \
    NODE_VERSION="9.2.0" \
    GIT_VERSION="2.15.0" \
    PHP_VERSION="71"

ADD mariadb.repo /etc/yum.repos.d/mariadb.repo

RUN \
  rpm --rebuilddb && yum clean all && rm -rf /var/cache/yum && \
  yum update -y && \
  yum install -y \
    wget \
    patch \
    bzip2 \
    unzip \
    make \
    openssh-clients \
    MariaDB-client && \
  rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
  yum install -y \
    php${PHP_VERSION}-php \
    php${PHP_VERSION}-php-bcmath \
    php${PHP_VERSION}-php-cli \
    php${PHP_VERSION}-php-common \
    php${PHP_VERSION}-php-devel \
    php${PHP_VERSION}-php-fpm \
    php${PHP_VERSION}-php-gd \
    php${PHP_VERSION}-php-gmp \
    php${PHP_VERSION}-php-intl \
    php${PHP_VERSION}-php-json \
    php${PHP_VERSION}-php-mbstring \
    php${PHP_VERSION}-php-mcrypt \
    php${PHP_VERSION}-php-mysqlnd \
    php${PHP_VERSION}-php-opcache \
    php${PHP_VERSION}-php-pdo \
    php${PHP_VERSION}-php-pear \
    php${PHP_VERSION}-php-process \
    php${PHP_VERSION}-php-pspell \
    php${PHP_VERSION}-php-xml \
    php${PHP_VERSION}-php-pecl-imagick \
    php${PHP_VERSION}-php-pecl-mysql \
    php${PHP_VERSION}-php-pecl-uploadprogress \
    php${PHP_VERSION}-php-pecl-uuid \
    php${PHP_VERSION}-php-pecl-zip && \
  ln -sfF /opt/remi/php${PHP_VERSION}/enable /etc/profile.d/php${PHP_VERSION}-paths.sh && \
  ln -sfF /opt/remi/php${PHP_VERSION}/root/usr/bin/{pear,pecl,phar,php,php-cgi,php-config,phpize} /usr/local/bin/. && \
  mv -f /etc/opt/remi/php${PHP_VERSION}/php.ini /etc/php.ini && ln -s /etc/php.ini /etc/opt/remi/php${PHP_VERSION}/php.ini && \
  rm -rf /etc/php.d && mv /etc/opt/remi/php${PHP_VERSION}/php.d /etc/. && ln -s /etc/php.d /etc/opt/remi/php${PHP_VERSION}/php.d && \
  yum install -y \
    ImageMagick \
    GraphicsMagick \
    gcc \
    gcc-c++ \
    libffi-devel \
    libpng-devel \
    zlib-devel && \
  yum install -y ruby ruby-devel && \
  echo 'gem: --no-document' > /etc/gemrc && \
  gem update --system && \
  gem install bundler && \
  yum list installed | cut -f 1 -d " " | uniq | sort > /tmp/yum-pre && \
  yum install -y \
    automake \
    autoconf \
    libtool \
    openssl-devel \
    curl-devel \
    expat-devel \
    gettext-devel \
    perl-ExtUtils-MakeMaker \
    httpd-devel && \
  cd /tmp && \
  wget https://www.kernel.org/pub/software/scm/git/git-$GIT_VERSION.tar.gz && \
  tar -zxf git-$GIT_VERSION.tar.gz --no-same-owner && \
  cd git-$GIT_VERSION && \
  make prefix=/usr/local all && \
  make prefix=/usr/local install && \
  cd /tmp && rm -rf /tmp/git* && \
  yum list installed | cut -f 1 -d " " | uniq | sort > /tmp/yum-post && \
  diff /tmp/yum-pre /tmp/yum-post | grep "^>" | cut -f 2 -d ' ' | xargs yum erase -y && \
  export PROFILE=/etc/profile.d/nvm.sh && touch $PROFILE && \
  curl -sSL https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash && \
  source $NVM_DIR/nvm.sh && \
  nvm install $NODE_VERSION && \
  nvm alias default $NODE_VERSION && \
  nvm use default && \
  npm install -g \
    gulp \
    grunt-cli \
    bower \
    browser-sync && \
  echo -e "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
  yum install -y libmemcached-devel && \
  git clone https://github.com/php-memcached-dev/php-memcached.git && cd php-memcached && git checkout php7 && \
  phpize && ./configure && make && make install && \
  echo "extension=memcached.so" > /etc/php.d/50-memcached.ini && \
  git clone https://github.com/phpredis/phpredis.git && cd phpredis && git checkout master && \
  phpize && ./configure && make && make install && \
  echo "extension=redis.so" > /etc/php.d/50-redis.ini && \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
  chown apache /usr/local/bin/composer && composer --version && \
  yum clean all && rm -rf /tmp/yum* && \
  sed -i 's|SetHandler application/x-httpd-php|SetHandler "proxy:fcgi://127.0.0.1:9000"|g' /etc/httpd/conf.d/php${PHP_VERSION}-php.conf

ADD container-files /

ENV \
  NODE_PATH=$NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules \
  PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH