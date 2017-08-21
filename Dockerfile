FROM ubuntu:14.04
MAINTAINER Lorello <lsalvadorini@cloud4wi.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q && \
    apt-get install -y --no-install-recommends unzip python-software-properties software-properties-common && \
    add-apt-repository -y ppa:sergey-dryabzhinsky/php53 && \
    add-apt-repository -y ppa:sergey-dryabzhinsky/packages && \
    add-apt-repository -y ppa:sergey-dryabzhinsky/php-modules && \
    apt-get update -q && \

    apt-get install -y --no-install-recommends \
      wget apache2 libapache2-mod-php53 apache2-mpm-prefork \
      php53-common php53-cli php53-mod-gd php53-mod-mysqlnd \
      php53-mod-bcmath php53-mod-calendar php53-mod-bz2 \
      php53-mod-soap php53-mod-xml php53-mod-xmlreader php53-mod-xmlwriter \
      php53-mod-ftp php53-mod-imap php53-mod-dom php53-mod-exif \
      php53-mod-fileinfo php53-mod-gettext php53-mod-gmp php53-mod-json \
      php53-mod-mbstring php53-mod-openssl php53-mod-phar php53-mod-pcntl \
      php53-mod-simplexml php53-mod-curl php53-mod-readline php53-mod-tokenizer \
      php53-mod-wddx php53-mod-xsl php53-mod-redis php53-mod-opcache \ 
      php53-mod-mongo php53-mod-mcrypt postfix && \
      mkdir -p /var/lock/apache2 && mkdir -p /var/run/apache2 && \
      a2dismod mpm_event && a2enmod mpm_prefork && \
      rm -rf /var/lib/apt/lists/*

COPY apache_default /etc/apache2/sites-available/000-default.conf
COPY run /usr/local/bin/run
COPY php.ini /etc/php.ini

RUN wget -q https://getcomposer.org/installer -O- | php -- --install-dir=/usr/local/bin --filename=composer && \
    chmod +x /usr/local/bin/composer

RUN chmod +x /usr/local/bin/run && \
    a2enmod rewrite php53 && \
    rm -rf /etc/php53/cli/conf.d /etc/php53/apache2/conf.d && \
    ln -s /etc/php53/conf.d /etc/php53/cli/conf.d && \
    ln -s /etc/php53/conf.d /etc/php53/apache2/conf.d

ENV CONSUL_TEMPLATE_VERSION 0.19.0
RUN wget -q https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
  && unzip consul-template_*.zip -d /usr/bin \
  && rm consul-template_*.zip

EXPOSE 80
CMD ["/usr/local/bin/run"]

