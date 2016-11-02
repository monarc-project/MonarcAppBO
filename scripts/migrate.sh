#!/bin/bash

BUILD=$1

cd /var/www/continuousphp/$BUILD

while [ ! -f /var/lib/continuousphp/credentials.ini ]
do
  sleep 2
done

chown -R www-data:www-data /var/www/continuousphp/$BUILD/*
bin/phing -propertyfile /var/lib/continuousphp/credentials.ini init