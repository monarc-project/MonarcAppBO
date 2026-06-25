#!/usr/bin/env bash

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

checkout_repo_ref() {
    if [ -d "$1" ]; then
        pushd "$1"
        if [[ -n "$2" ]]; then
            git fetch origin "$2"
            if git show-ref --verify --quiet "refs/heads/$2"; then
                git checkout "$2"
            else
                git checkout -B "$2" --track "origin/$2"
            fi
            git pull origin "$2"
        else
            git fetch --tags
            tag=$(git describe --tags `git rev-list --tags --max-count=1`)
            if git show-ref --verify --quiet "refs/heads/$tag"; then
                git checkout "$tag"
            else
                git checkout -b "$tag" "$tag"
            fi
            git pull origin "$tag"
        fi
        popd
    fi
}

checkout_to_ref_if_set_or_latest_tag() {
    if [ -d "$1" ]; then
        checkout_repo_ref "$1" "$2"
    fi
}

pull_if_exists() {
	if [ -d $1 ]; then
		pushd $1
		git pull
		popd
	fi
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

git pull

if [ $? != 0 ]; then
	echo "A problem occurred while retrieving remote files from repository."
	exit 1
fi

./scripts/check_composer.sh
if [[ $? -eq 1 ]]; then
    exit 1
fi

composer install -o --no-dev

pathCore="module/Monarc/Core"
pathBO="module/Monarc/BackOffice"

if [[ $bypass -eq 0 ]]; then
	migrate_module $pathCore
	migrate_module $pathBO
fi

if [[ -d node_modules && -d node_modules/ng_anr ]]; then
	if [[ -d node_modules/ng_anr/.git ]]; then
		checkout_to_ref_if_set_or_latest_tag node_modules/ng_backoffice "$frontendRef"
		checkout_to_ref_if_set_or_latest_tag node_modules/ng_anr "$frontendRef"
	else
		npm update
	fi
fi

cd node_modules/ng_backoffice
npm ci
cd ../..

./scripts/link_modules_resources.sh
./scripts/compile_translations.sh


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
