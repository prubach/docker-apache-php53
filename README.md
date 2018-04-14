apache-php
===================================

A Docker image based on Ubuntu 14.04, serving the old PHP 5.3 running as Apache Module. Useful for Web developers in need for an old PHP version.

Tags
-----

* latest: Ubuntu 14.04 (LTS), Apache 2.4, PHP 5.3.29
* Enabled register_globals = On
* Added support for postgres in PHP

Usage
------

Build image:
```
./build.sh
```
* Place your application in data/webapp (or symlink to that folder).

* Modify run_image.sh according to your needs, replacing 172.17.0.1 with the IP of your machine so that the Apache web server can communicate with MySQL or Postgres.

```
#!/bin/bash

NAME="gidle_php53"
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo $DIR
docker run --add-host="localhost:172.17.0.1" -d \
    -p 80:80 \
    -v $DIR/data/webapp:/var/www/html \
    -v $DIR/data/vhost:/etc/httpd/vhost.d \
    -v $DIR/php.ini:/etc/php.ini \
    --restart=always \
    --name $NAME \
gidle/php53
```

Run it:
```
./run_image.sh 
```

### Access apache logs

Apache is configured to log both access and error log to STDOUT. So you can simply use `docker logs` to get the log output:

`docker logs -f container-id`
