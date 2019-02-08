FROM php:7.1-fpm

ENV apt_install="apt install -y --no-install-recommends"

ENV DEBIAN_FRONTEND noninteractive

RUN apt update 
RUN $apt_install apt-utils


# package git is needed for composer install command
RUN $apt_install git 

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
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN $apt_install mysql-client

