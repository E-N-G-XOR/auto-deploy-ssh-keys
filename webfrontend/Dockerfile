FROM ubuntu:latest
MAINTAINER Dan Pupius <dan@pupi.us>

# Install apache, PHP, and supplimentary programs. openssh-server, curl, and lynx-cur are for debugging the container.
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 php php-mysql libapache2-mod-php curl mysql-client nano

# Enable apache mods.
#RUN a2enmod php
RUN a2enmod rewrite
RUN a2enmod remoteip

# Install CloudFlare
RUN DEBIAN_FRONTEND=noninteractive apt-get install apache2-dev libtool git -y
RUN cd /root/ && git clone https://github.com/cloudflare/mod_cloudflare.git && cd mod_cloudflare && apxs -a -i -c mod_cloudflare.c
RUN echo 'CloudflareRemoteIPTrustedProxy 165.227.71.190 165.227.71.249 138.197.50.141' >> /etc/apache2/apache2.conf

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
#RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/apache2/php.ini
#RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.0/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Copy site into place.
ADD public_html /var/www/site/app

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND
