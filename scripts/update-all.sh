#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

bypass=0
forceClearCache=0
frontendRef=""
while getopts "hbcf:" option
do
	case $option in
		h)
			echo -e "Update or install all Monarc modules, frontend views and migrate database."
			echo -e "\t-b\tbypass migrate database"
			echo -e "\t-c\tforce clear cache"
			echo -e "\t-f\tfrontend git branch/tag to use for ng_backoffice and ng_anr"
			echo -e "\t-h\tdisplay this message"
			exit 1
			;;
		b)
			bypass=1
			echo "Migrate database don't execute !!!"
			;;
		c)
			forceClearCache=1
			;;
		f)
			frontendRef="$OPTARG"
			;;
	esac
done

bash "$(dirname "${BASH_SOURCE[0]}")/check_node.sh"

checkout_repo_ref() {
    if [[ ! -d "$1/.git" || -L "$1" ]]; then
        echo "A frontend ref override requires an independent Git checkout: $1" >&2
        exit 1
    fi
    if [[ -n "$(git -C "$1" status --porcelain --untracked-files=no)" ]]; then
        echo "Preserve tracked changes in $1 before changing its revision." >&2
        exit 1
    fi
    git -C "$1" fetch origin "$2"
    git -C "$1" checkout --detach FETCH_HEAD
}

migrate_module() {
	if [[ -d $1 ]]; then
		php ./vendor/robmorgan/phinx/bin/phinx migrate -c ./$1/migrations/phinx.php
	fi
}

if [[ ! -f "config/autoload/local.php" && $bypass -eq 0  ]]; then
	echo "Configure Monarc (config/autoload/local.php)"
	exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "No .git metadata; skipping git pull."
elif git rev-parse --verify --quiet '@{upstream}' >/dev/null 2>&1; then
    git pull || { echo "A problem occurred while retrieving remote files from repository."; exit 1; }
else
    echo "No upstream configured for the current checkout; skipping git pull."
fi

./scripts/check_composer.sh
if [[ $? -eq 1 ]]; then
    exit 1
fi

composer install -o --no-dev

# Prepare the frontend before changing the database. Local links belong to the
# developer and must never be replaced with release checkouts during an update.
if [[ -n "$frontendRef" ]]; then
    checkout_repo_ref node_modules/ng_backoffice "$frontendRef"
    checkout_repo_ref node_modules/ng_anr "$frontendRef"
    (cd node_modules/ng_backoffice && npm ci)
elif [[ -L node_modules/ng_anr || -L node_modules/ng_backoffice ]]; then
    for target in node_modules/ng_anr node_modules/ng_backoffice; do
        if [[ ! -L "$target" || ! -d "$target" ]]; then
            echo "Local frontend sources require two valid links; run switch_repo_sources.sh local." >&2
            exit 1
        fi
    done
    (cd node_modules/ng_backoffice && npm ci)
else
    ./scripts/install-frontend.sh
fi
./scripts/link_modules_resources.sh
./scripts/compile_translations.sh

pathCore="module/Monarc/Core"
pathBO="module/Monarc/BackOffice"

if [[ $bypass -eq 0 ]]; then
	migrate_module $pathCore
	migrate_module $pathBO
fi

if [[ $forceClearCache -eq 1 ]]; then
	# Clear doctrine cache
	# Move to Monarc/Core Module.php
	php ./public/index.php orm:clear-cache:metadata
	php ./public/index.php orm:clear-cache:query
	php ./public/index.php orm:clear-cache:result

	# Clear cache
	if [ -e ./data/cache/upgrade ]
	then
		touch ./data/cache/upgrade && chmod 777 ./data/cache/upgrade
	fi
fi

if [[ $forceClearCache -eq 0 && $bypass -eq 0 ]]; then
	# Clear cache
	if [ -e ./data/cache/upgrade ]
	then
		touch ./data/cache/upgrade && chmod 777 ./data/cache/upgrade
	fi
fi

exit 0
