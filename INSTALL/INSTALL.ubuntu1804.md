Installation on Ubuntu 16.04
============================

# 1. Install LAMP & dependencies

## Install the dependencies

    $ sudo apt-get install vim zip unzip git gettext curl

Some might already be installed.

## Install MariaDB

    $ sudo apt-get install mariadb-client mariadb-server

# Secure the MariaDB installation

    $ sudo mysql_secure_installation

Especially by setting a strong root password.

## Install Apache2

    $ sudo apt-get install apache2

## Enable modules, settings, and default of SSL in Apache

    $ sudo a2dismod status
    $ sudo a2enmod ssl
    $ sudo a2enmod rewrite
    $ sudo a2enmod headers

## Apache Virtual Host

    <VirtualHost *:80>
        ServerName monarc.localhost
        DocumentRoot /var/lib/monarc/bo/MonarcAppBO/public

        <Directory /var/lib/monarc/bo/MonarcAppBO/public>
            DirectoryIndex index.php
            AllowOverride All
            Require all granted
        </Directory>

        SetEnv APPLICATION_ENV "development"
    </VirtualHost>


## Install PHP and dependencies

    $ sudo apt-get install php apache2 libapache2-mod-php php-curl php-gd php-mysql php-pear php-apcu php-xml php-mbstring php-intl php-imagick php-zip

## Apply all changes

    $ sudo systemctl restart apache2.service



# 2. Installation of MONARC

## MONARC code

Clone the repository and invoke `composer` using the shipped `composer.phar`:

    $ cd /var/lib/monarc/bo/
    $ git clone https://github.com/monarc-project/MonarcAppBO.git
    $ cd MonarcAppBO/
    $ chown -R www-data data
    $ chmod -R g+w data
    $ sudo composer self-update
    $ composer install -o

The `self-update` directive is to ensure you have an up-to-date `composer.phar`
available.


### Backend

The backend is not directly modules of the project but libraries.
You must create modules with symbolic links to libraries.

Create two symbolic links:

    $ mkdir module
    $ cd module/
    $ ln -s ./../vendor/monarc/core MonarcCore
    $ ln -s ./../vendor/monarc/backoffice MonarcBO

There are 2 parts:

* MonarcBO is only for back office;
* MonarcCore is common to the front office and to the back office.


### Frontend

The frontend is an AngularJS application.

    $ mkdir node_modules
    $ cd node_modules
    $ git clone https://github.com/monarc-project/ng-backoffice.git ng_backoffice
    $ git clone https://github.com/monarc-project/ng-anr.git ng_anr

There are 2 parts:

* one only for back office: ng_backoffice;
* one common for front office and back office: ng_anr.


## Databases

### Create 2 databases

In your MariaDB interpreter:

    CREATE DATABASE monarc_master DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
    CREATE DATABASE monarc_common DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;

* monarc_common contains models and data created by CASES;
* monarc_master contains all user and organization information.

### Initializes the database

    $ mysql -u user monarc_common < db-bootstrap/monarc_structure.sql
    $ mysql -u user monarc_common < db-bootstrap/monarc_data.sql

### Database connection

Create the configuration file:

    $ sudo cp ./config/autoload/local.php.dist ./config/autoload/local.php

And configure the database connection:

    return array(
        'doctrine' => array(
            'connection' => array(
                'orm_default' => array(
                    'params' => array(
                        'host' => 'host',
                        'user' => 'user',
                        'password' => 'password',
                        'dbname' => 'monarc_common',
                    ),
                ),
                'orm_cli' => array(
                    'params' => array(
                        'host' => 'host',
                        'user' => 'user',
                        'password' => 'password',
                        'dbname' => 'monarc_master',
                    ),
                ),
            ),
        ),
    );



# Update MONARC

## Install Grunt

    $ sudo apt-get -y install npm
    $ npm install -g grunt-cli


Update MONARC:

    $ ./scripts/update-all.sh


# Create initial user

    $ php ./vendor/robmorgan/phinx/bin/phinx seed:run -c ./module/MonarcBO/migrations/phinx.php


The username is *admin@admin.test* and the password is *admin*.
