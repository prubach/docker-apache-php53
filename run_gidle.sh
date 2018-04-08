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
