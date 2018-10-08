MONARC - Back Office
====================

The back office is especially needed if you want to manage several clients.
For more information you can have a look at
[the differences](https://www.monarc.lu/product/#features-summary) with MONARC
itself or you can check the
[MONARC architecture](https://www.monarc.lu/documentation/technical-guide/#monarc-and-the-back-office).


Installation
------------

PHP & MySQL
-----------

Install PHP (version 7.2 recommended) with Apache with extensions:
xml, mbstring, mysql, zip, unzip, mcrypt, intl, imagick (extension php)

For Apache add mods : rewrite, ssl (a2enmod)

Install MariaDb.


Using Composer (recommended)
----------------------------

If not already done, install composer relevant to your distribution. Then,
clone the repository and manually invoke `composer`:

    $ cd my/project/dir
    $ git clone https://github.com/monarc-project/MonarcAppBO.git
    $ cd MonarcAppBO/
    $ composer self-update
    $ composer install -o

The `self-update` ensures you have an up-to-date `composer.phar` available.

![Arbo](public/img/arbo1.png "Arbo")


Databases
---------
Create 2 databases:

    CREATE DATABASE monarc_master DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
    CREATE DATABASE monarc_common DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;

* monarc_common contains models and data create by CASES.
* monarc_master contains all user and authentication information.

Once the databases are created, extract and import the extracted file to the ***monarc_common*** database:

    $ tar -xzvf db-bootstrap/monarc-common.tar.gz -C db-bootstrap/
    $ mysql -u sqlmonarcuser -p monarc_common < db-bootstrap/monarc-common.sql


Back-end
--------

The project is splited on 2 parts:

* an Api in charge of retrieve data
* an interface to display data

The API is not a module of the project but libraries.
You must create modules with symbolic links to the libraries:

    $ mkdir module
    $ cd module
    $ ln -s ./../vendor/monarc/core MonarcCore
    $ ln -s ./../vendor/monarc/backoffice MonarcBO


There are 2 parts:

* one only for front office
* one common for front office and back office (private project)


![Arbo](public/img/arbo2.png "Arbo")


Front-end
---------

Repositories for AngularJS:

    $ mkdir node_modules
    $ cd node_modules
    $ git clone https://github.com/monarc-project/ng-backoffice.git ng_backoffice
    $ git clone https://github.com/monarc-project/ng-anr.git ng_anr

 There are 2 parts:
 * one only for front office (ng_client)
 * one common for front office and back office (private project) (ng_anr)


![Arbo](public/img/arbo3.png "Arbo")


Web Server Setup
----------------

### Apache Setup

To setup Apache, setup a virtual host to point to the public/ directory of the
project and you should be ready to go! It should look something like below:

    <VirtualHost 0.0.0.0:80>
        ServerName monarc.localhost
        DocumentRoot /path/to/monarc/public
        SetEnv APPLICATION_ENV "development"
        <Directory /path/to/monarc/public>
            DirectoryIndex index.php
            AllowOverride All
            Require All Granted
        </Directory>
    </VirtualHost>


Database connection
-------------------

Create file `config/autoload/local.php`:

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



Configuration
-------------

Create file configuration

    $ sudo cp /config/autoload/local.php.dist /config/autoload/local.php

Update connection information to local.php and global.php

Configuration files are stored in cache.
If yours changes have not been considered, empty cache by deleting file in /data/cache
You might need to create the folders. Also, the /data/cache folder needs to be
owned by the internet user (www-data in ubuntu).

Install Grunt
-------------

    $ sudo apt-get -y install npm
    $ npm install -g grunt-cli

Update project
--------------
Play script (mandatory from the root of the project)(pull and migrations):

    $ ./scripts/update-all.sh


Create Initial User and Client
------------------------------

Create first user:

    $ php ./vendor/robmorgan/phinx/bin/phinx seed:run -c ./module/MonarcBO/migrations/phinx.php

The username is *admin@admin.test* and the password is *admin*.


Data Model
----------

monarc_common
![monarc_common](public/img/model-common.png "monarc_common")



License
-------

This software is licensed under
[GNU Affero General Public License version 3](http://www.gnu.org/licenses/agpl-3.0.html)

- Copyright (C) 2016-2018 Jérôme Lombardi - https://github.com/jerolomb
- Copyright (C) 2016-2018 Juan Rocha - https://github.com/jfrocha
- Copyright (C) 2016-2018 SMILE gie securitymadein.lu
- Copyright (C) 2017-2018 Cédric Bonhomme - https://github.com/cedricbonhomme
- Copyright (C) 2016-2017 Guillaume Lesniak
- Copyright (C) 2016-2017 Thomas Metois
- Copyright (C) 2016-2017 Jérôme De Almeida

For more information, [the list of authors and contributors](AUTHORS) is available.

Data provided with MONARC (threats, assets, vulnerabilities) are licensed under    
[CC0 1.0 Universal (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/) - Public Domain Dedication.
If a specific author wants to license an object under a different license,
a pull request can be requested.
