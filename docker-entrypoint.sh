#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting MONARC BackOffice setup...${NC}"

# Wait for database to be ready
echo -e "${YELLOW}Waiting for MariaDB to be ready...${NC}"
export MYSQL_PWD="${DBPASSWORD_MONARC}"
while ! mysqladmin ping -h"${DBHOST}" -u"${DBUSER_MONARC}" --silent 2>/dev/null; do
    echo "Waiting for MariaDB..."
    sleep 2
done
echo -e "${GREEN}MariaDB is ready!${NC}"

# Check if this is the first run
if [ ! -f "/var/www/html/monarc/.docker-initialized" ]; then
    echo -e "${GREEN}First run detected, initializing application...${NC}"

    cd /var/www/html/monarc

    # Install composer dependencies (always, to ensure binaries like Phinx are present)
    echo -e "${YELLOW}Installing Composer dependencies...${NC}"
    # Using --ignore-platform-req=php to allow flexibility in development environment
    # This is acceptable for development but should not be used in production
    composer install --ignore-platform-req=php --no-interaction

    # Create module symlinks
    echo -e "${YELLOW}Creating module symlinks...${NC}"
    mkdir -p module/Monarc
    cd module/Monarc
    ln -sfn ./../../vendor/monarc/core Core
    ln -sfn ./../../vendor/monarc/backoffice BackOffice
    cd /var/www/html/monarc

    # Clone frontend repositories
    echo -e "${YELLOW}Setting up frontend repositories...${NC}"
    mkdir -p node_modules
    cd node_modules

    if [ ! -d "ng_backoffice" ]; then
        git clone --config core.fileMode=false https://github.com/monarc-project/ng-backoffice.git ng_backoffice
    fi

    if [ ! -d "ng_anr" ]; then
        git clone --config core.fileMode=false https://github.com/monarc-project/ng-anr.git ng_anr
    fi

    cd /var/www/html/monarc

    # Check if master database exists and create databases if needed
    echo -e "${YELLOW}Setting up databases...${NC}"
    DB_EXISTS=$(mysql -h"${DBHOST}" -u"root" -p"${DBPASSWORD_ADMIN}" -e "SHOW DATABASES LIKE '${DBNAME_MASTER}';" | grep -c "${DBNAME_MASTER}" || true)

    if [ "$DB_EXISTS" -eq 0 ]; then
        echo -e "${YELLOW}Creating databases...${NC}"
        mysql -h"${DBHOST}" -u"root" -p"${DBPASSWORD_ADMIN}" -e "CREATE DATABASE IF NOT EXISTS ${DBNAME_MASTER} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
        mysql -h"${DBHOST}" -u"root" -p"${DBPASSWORD_ADMIN}" -e "CREATE DATABASE IF NOT EXISTS ${DBNAME_COMMON} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"

        echo -e "${YELLOW}Granting privileges to ${DBUSER_MONARC}...${NC}"
        mysql -h"${DBHOST}" -u"root" -p"${DBPASSWORD_ADMIN}" -e "GRANT ALL PRIVILEGES ON ${DBNAME_MASTER}.* TO '${DBUSER_MONARC}'@'%';"
        mysql -h"${DBHOST}" -u"root" -p"${DBPASSWORD_ADMIN}" -e "GRANT ALL PRIVILEGES ON ${DBNAME_COMMON}.* TO '${DBUSER_MONARC}'@'%';"
        mysql -h"${DBHOST}" -u"root" -p"${DBPASSWORD_ADMIN}" -e "FLUSH PRIVILEGES;"

        echo -e "${YELLOW}Populating common database...${NC}"
        mysql -h"${DBHOST}" -u"${DBUSER_MONARC}" ${DBNAME_COMMON} < db-bootstrap/monarc_structure.sql
        mysql -h"${DBHOST}" -u"${DBUSER_MONARC}" ${DBNAME_COMMON} < db-bootstrap/monarc_data.sql
    fi

    # Generate local config (always override to match container DB)
    echo -e "${YELLOW}Creating local configuration...${NC}"
    cat > config/autoload/local.php <<EOF
<?php
\$appdir = getenv('APP_DIR') ? getenv('APP_DIR') : '/var/www/html/monarc';
\$string = file_get_contents(\$appdir.'/package.json');
if(\$string === FALSE) {
    \$string = file_get_contents('./package.json');
}
\$package_json = json_decode(\$string, true);

return [
    'doctrine' => [
        'connection' => [
            'orm_default' => [
                'params' => [
                    'host' => '${DBHOST}',
                    'user' => '${DBUSER_MONARC}',
                    'password' => '${DBPASSWORD_MONARC}',
                    'dbname' => '${DBNAME_COMMON}',
                ],
            ],
            'orm_cli' => [
                'params' => [
                    'host' => '${DBHOST}',
                    'user' => '${DBUSER_MONARC}',
                    'password' => '${DBPASSWORD_MONARC}',
                    'dbname' => '${DBNAME_MASTER}',
                ],
            ],
        ],
    ],

    'activeLanguages' => array('fr','en','de','nl','es','ro','it','ja','pl','pt','ru','zh'),

    'appVersion' => \$package_json['version'],

    'checkVersion' => false,
    'appCheckingURL' => 'https://version.monarc.lu/check/MONARC',

    'email' => [
        'name' => 'MONARC',
        'from' => 'info@monarc.lu',
    ],

    'mospApiUrl' => 'https://objects.monarc.lu/api/',

    'monarc' => [
        'ttl' => 60, // timeout
        'salt' => '', // private salt for password encryption
    ],
];
EOF

    # Update and build frontend and run DB migrations
    echo -e "${YELLOW}Building frontend and running DB migrations...${NC}"
    ./scripts/update-all.sh

    # Create initial user and client (seeds are idempotent)
    echo -e "${YELLOW}Creating initial user and client...${NC}"
    php ./vendor/robmorgan/phinx/bin/phinx seed:run -c ./module/Monarc/BackOffice/migrations/phinx.php

    # Set permissions
    echo -e "${YELLOW}Setting permissions...${NC}"
    chown -R www-data:www-data /var/www/html/monarc/data
    chmod -R 775 /var/www/html/monarc/data

    # Mark initialization as complete
    touch /var/www/html/monarc/.docker-initialized
    echo -e "${GREEN}Initialization complete!${NC}"
else
    echo -e "${GREEN}Application already initialized, starting services...${NC}"
fi

# Execute the main command
exec "$@"
