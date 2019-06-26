FROM keywanghadamioxid/php-fpm-oxid

RUN $apt_install python3 python3-pip openssh-client
RUN /usr/bin/pip3 install PyMySQL ansible
