FROM php:7.1-fpm

ENV apt_install="apt install -y --no-install-recommends"

ENV DEBIAN_FRONTEND noninteractive

RUN apt update

# package git is needed for composer install command
RUN $apt_install apt-utils git

# php gd support
RUN $apt_install libjpeg62-turbo-dev libpng-dev libfreetype6-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ 
RUN docker-php-ext-install -j$(nproc) gd

#mycrypt
#RUN apt-get install -y  --no-install-recommends libmcrypt
#RUN docker-php-ext-install -j$(nproc) mcrypt

RUN docker-php-ext-install -j$(nproc) mbstring iconv  bcmath

#PHP soap support: 
RUN $apt_install libxml2-dev && docker-php-ext-install -j$(nproc) soap

#PHP database extensions database (mysql)
RUN docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql

RUN $apt_install autoconf $PHPIZE_DEPS && pecl install xdebug-2.6.0 && docker-php-ext-enable xdebug


RUN $apt_install unzip
RUN docker-php-ext-install -j$(nproc) zip

RUN $apt_install mysql-client sudo
RUN echo ALL ALL=NOPASSWD: ALL>>/etc/sudoers

ENV COMPOSER_VERSION master
#ENV COMPOSER_ALLOW_SUPERUSER 1
#ENV COMPOSER_HOME /tmp

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN $apt_install mysql-client

RUN $apt_install python3 python3-setuptools python3-wheel python3-pip openssh-client
RUN /usr/bin/pip3 install PyMySQL ansible

RUN $apt_install nano net-tools

RUN printf "# composer php cli ini settings\n\
date.timezone=UTC\n\
memory_limit=-1\n\
" > $PHP_INI_DIR/php-cli.ini

RUN printf "#! /bin/bash \n\
export XDEBUG_CONFIG=\"idekey=PHPSTORM\" \n\
export PHP_IDE_CONFIG=\"serverName=PHP_FROM_DOCKER\" \n\
php \"\$@\" \n\
" > /usr/local/bin/phpd

RUN chmod +x /usr/local/bin/phpd

# /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN printf "# xdebug php settings\n\
xdebug.remote_enable=1 \n\
xdebug.remote_connect_back=1 \n\
xdebug.remote_host=172.26.0.1 \n\
xdebug.idekey=PHPStorm \n\
" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini
