#!/bin/bash
service apache2 restart > /dev/null 2>&1 &
service php7.0-fpm restart > /dev/null 2>&1 &
