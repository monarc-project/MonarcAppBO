#!/usr/bin/env bash
set -eo pipefail

source /etc/os-release
if [[ "$ID" != ubuntu || "$VERSION_ID" != 26.04 ]]; then
    echo 'This bootstrap requires a fresh Ubuntu 26.04 Vagrant guest.' >&2
    exit 1
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

PATH_TO_MONARC='/home/vagrant/monarc'

ENVIRONMENT='development'

DBHOST='localhost'
DBNAME_COMMON='monarc_common'
DBNAME_MASTER='monarc_master'
DBUSER_MONARC='sqlmonarcuser'
DBPASSWORD_MONARC='sqlmonarcuser'

upload_max_filesize=200M
post_max_size=50M
max_execution_time=100
max_input_time=223
memory_limit=512M

PHP_INI=/etc/php/8.4/apache2/php.ini
XDEBUG_CFG=/etc/php/8.4/apache2/conf.d/20-xdebug.ini
MARIA_DB_CFG=/etc/mysql/mariadb.conf.d/50-server.cnf

export DEBIAN_FRONTEND=noninteractive
export LANGUAGE=C.UTF-8
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

echo -e "\n--- Installing now… ---\n"

echo -e "\n--- Updating packages list ---\n"
sudo apt-get update
sudo apt-get upgrade -y

echo -e "\n--- Install base packages… ---\n"
sudo apt-get -y install vim zip unzip xz-utils git gettext curl ca-certificates gsfonts locales \
    build-essential python3 pkg-config libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev > /dev/null
sudo localedef -i en_US -f UTF-8 en_US.UTF-8
sudo update-locale LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


echo -e "\n--- Install MariaDB specific packages and settings… ---\n"
sudo apt-get -y install mariadb-server mariadb-client > /dev/null

# Ubuntu's MariaDB root account uses local Unix-socket authentication.
sudo systemctl restart mariadb.service > /dev/null
sudo mariadb -u root <<'SQL'
DELETE FROM mysql.global_priv WHERE User = '';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db = 'test' OR Db LIKE 'test\_%';
FLUSH PRIVILEGES;
SQL

echo -e "\n--- Configuring… ---\n"
sudo sed -i "s/skip-external-locking/#skip-external-locking/g" $MARIA_DB_CFG
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" $MARIA_DB_CFG
sudo sed -i "s/.*character-set-server.*/character-set-server = utf8mb4/" $MARIA_DB_CFG
sudo sed -i "s/.*collation-server.*/collation-server = utf8mb4_general_ci/" $MARIA_DB_CFG

echo -e "\n--- Setting up our MariaDB user for MONARC… ---\n"
sudo mariadb -u root -e "CREATE USER '$DBUSER_MONARC'@'%' IDENTIFIED BY '$DBPASSWORD_MONARC';"
sudo mariadb -u root -e "GRANT ALL PRIVILEGES ON * . * TO '$DBUSER_MONARC'@'%';"
sudo mariadb -u root -e "FLUSH PRIVILEGES;"
sudo systemctl restart mariadb.service > /dev/null

echo -e "\n--- Installing Apache… ---\n"
sudo apt install apache2 -y

echo -e "\n--- Installing PHP-specific packages… ---\n"
# Ubuntu 26.04 ships PHP 8.5; use the maintainer's repository for PHP 8.4.
php_keyring=$(mktemp)
curl -fsSL https://packages.sury.org/debsuryorg-archive-keyring.deb -o "$php_keyring"
sudo dpkg -i "$php_keyring" > /dev/null
rm -f "$php_keyring"
printf '%s\n' 'deb [signed-by=/usr/share/keyrings/debsuryorg-archive-keyring.gpg] https://packages.sury.org/php/ resolute main' \
    | sudo tee /etc/apt/sources.list.d/php.list > /dev/null
sudo apt-get update > /dev/null
sudo apt-get install -y libapache2-mod-php8.4 php8.4 php8.4-cli php8.4-common php8.4-mysql \
    php8.4-zip php8.4-gd php8.4-mbstring php8.4-curl php8.4-xml php8.4-bcmath php8.4-intl \
    php8.4-imagick php8.4-xdebug > /dev/null || exit 1
if ! php8.4 -r 'exit(PHP_VERSION_ID >= 80428 && PHP_VERSION_ID < 80500 ? 0 : 1);'; then
    echo 'MONARC requires PHP >=8.4.28 <8.5.' >&2
    exit 1
fi
sudo update-alternatives --set php /usr/bin/php8.4 || exit 1
for php_module in /etc/apache2/mods-enabled/php*.load; do
    [ -e "$php_module" ] || continue
    php_module_name=$(basename "$php_module" .load)
    if [ "$php_module_name" != 'php8.4' ]; then
        sudo a2dismod "$php_module_name" > /dev/null || exit 1
    fi
done
sudo a2enmod php8.4 > /dev/null || exit 1

echo -e "\n--- Configuring PHP… ---\n"
for key in upload_max_filesize post_max_size max_execution_time max_input_time memory_limit
do
 sudo sed -i "s/^\($key\).*/\1 = $(eval echo \${$key})/" $PHP_INI
done

echo -e "\n--- Configuring Xdebug for development ---\n"
sudo bash -c "cat << EOF > $XDEBUG_CFG
zend_extension=xdebug.so
xdebug.mode=debug
xdebug.discover_client_host=1
xdebug.idekey=IDEKEY
EOF"

echo -e "\n--- Enabling mod-rewrite and ssl… ---\n"
sudo a2enmod rewrite > /dev/null 2>&1
sudo a2enmod ssl > /dev/null 2>&1
sudo a2enmod headers > /dev/null 2>&1

echo -e "\n--- Allowing Apache override to all ---\n"
sudo sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf


echo -e "\n--- Installing composer… ---\n"
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "\nERROR: unable to install composer\n"
    exit 1;
fi
sudo composer self-update

echo -e "\n--- Installing MONARC… ---\n"
cd $PATH_TO_MONARC
git config core.fileMode false

echo -e "\n--- Retrieving MONARC libraries… ---\n"
composer ins


# Make modules symlinks.
mkdir -p module/Monarc
cd module/Monarc
ln -s ./../../vendor/monarc/core Core
ln -s ./../../vendor/monarc/backoffice BackOffice
cd $PATH_TO_MONARC


mkdir -p $PATH_TO_MONARC/data/cache
mkdir -p $PATH_TO_MONARC/data/LazyServices/Proxy
mkdir -p $PATH_TO_MONARC/data/DoctrineORMModule/Proxy


# Front-end
echo -e "\n--- Installation of Node, NPM… ---\n"
# Keep the frontend build runtime aligned with the existing release images.
NODE_VERSION=16.20.2
case "$(dpkg --print-architecture)" in
    amd64) node_arch=x64 ;;
    arm64) node_arch=arm64 ;;
    *) echo 'The frontend build requires an amd64 or arm64 guest.' >&2; exit 1 ;;
esac
node_directory=$(mktemp -d)
node_archive="node-v${NODE_VERSION}-linux-${node_arch}.tar.xz"
curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/${node_archive}" -o "$node_directory/$node_archive"
curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/SHASUMS256.txt" -o "$node_directory/SHASUMS256.txt"
(cd "$node_directory" && sha256sum --check --ignore-missing SHASUMS256.txt)
sudo tar -xJf "$node_directory/$node_archive" -C /usr/local --strip-components=1 --no-same-owner
rm -rf "$node_directory"
node --version
npm --version
sudo npm install -g grunt-cli
# npm 8 bundles node-gyp 9, which relies on Python distutils removed in Ubuntu 26.04.
sudo npm explore npm/node_modules/@npmcli/run-script -g -- npm_config_global=false npm install node-gyp@10 --no-audit --no-fund

echo -e "\n--- Add a VirtualHost for MONARC ---\n"
sudo bash -c "cat << EOF > /etc/apache2/sites-enabled/000-default.conf
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot $PATH_TO_MONARC/public

    <Directory $PATH_TO_MONARC/public>
        DirectoryIndex index.php
        AllowOverride All
        Require all granted
    </Directory>

    SetEnv APP_ENV $ENVIRONMENT
    SetEnv APP_DIR $PATH_TO_MONARC

</VirtualHost>
EOF"
echo -e "\n--- Restarting Apache… ---\n"
sudo systemctl restart apache2.service > /dev/null


echo -e "\n--- Configuration of MONARC database connection ---\n"
cat > config/autoload/local.php <<EOF
<?php
return array(
    'doctrine' => [
        'connection' => [
            'orm_default' => [
                'params' => [
                    'host' => '$DBHOST',
                    'user' => '$DBUSER_MONARC',
                    'password' => '$DBPASSWORD_MONARC',
                    'dbname' => '$DBNAME_COMMON',
                ],
            ],
            'orm_cli' => [
                'params' => [
                    'host' => '$DBHOST',
                    'user' => '$DBUSER_MONARC',
                    'password' => '$DBPASSWORD_MONARC',
                    'dbname' => '$DBNAME_MASTER',
                ],
            ],
        ],
    ],

    // Public URL matches the host port in this Vagrantfile.
    'publicHost' => 'http://127.0.0.1:5000',

    'defaultLanguageIndex' => 1,

     // Languages available for the analysis / DB data.
    'languages' => [
        'fr' => ['index' => 1, 'label' => 'Français'],
        'en' => ['index' => 2, 'label' => 'English'],
        'de' => ['index' => 3, 'label' => 'Deutsch'],
        'nl' => ['index' => 4, 'label' => 'Dutch'],
    ],

    // Languages available for the user interface.
    'activeLanguages' => ['fr', 'en', 'de', 'nl', 'es', 'ro', 'it', 'ja', 'pl', 'pt', 'zh'],

    'monarc' => [
        'ttl' => 60,
    ],
);
EOF


echo -e "\n--- Creation of the data bases… ---\n"
mysql -u $DBUSER_MONARC -p$DBPASSWORD_MONARC -e "CREATE DATABASE monarc_master DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;" > /dev/null
mysql -u $DBUSER_MONARC -p$DBPASSWORD_MONARC -e "CREATE DATABASE monarc_common DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;" > /dev/null
echo -e "\n--- Populating MONARC DB… ---\n"
mysql -u $DBUSER_MONARC -p$DBPASSWORD_MONARC monarc_common < db-bootstrap/monarc_structure.sql > /dev/null
mysql -u $DBUSER_MONARC -p$DBPASSWORD_MONARC monarc_common < db-bootstrap/monarc_data.sql > /dev/null


echo -e "\n--- Adjusting user mod… ---\n"
sudo usermod -aG www-data vagrant
sudo usermod -aG vagrant www-data


echo -e "\n--- Update the project… ---\n"
./scripts/install-frontend.sh
./scripts/link_modules_resources.sh
./scripts/compile_translations.sh
./scripts/upgrade-db.sh


echo -e "\n--- Create initial user and client ---\n"
php ./vendor/robmorgan/phinx/bin/phinx seed:run -c ./module/Monarc/BackOffice/migrations/phinx.php > /dev/null


echo -e "\n--- Restarting Apache… ---\n"
sudo systemctl restart apache2.service > /dev/null


echo -e "\n--- MONARC is ready! Point your Web browser to http://127.0.0.1:5000 ---\n"
