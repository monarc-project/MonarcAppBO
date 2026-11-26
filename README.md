MONARC - Back Office
====================

The back office is especially needed if you want to manage several clients.
For more information you can have a look at
[the differences](https://www.monarc.lu/product/#features-summary) with MONARC
itself or you can check the
[MONARC architecture](https://www.monarc.lu/documentation/technical-guide/#monarc-and-the-back-office).


Documentation
-------------

You will find a user guide and a technical guide on the
[MONARC website](https://www.monarc.lu/documentation).

For installation instructions see
[INSTALL](https://github.com/monarc-project/MonarcAppBO/tree/master/INSTALL).


Development Environment
-----------------------

For local development, you can use either:

- **Docker** (recommended): See [README.docker.md](README.docker.md) for instructions
  ```bash
  make start
  ```

- **Vagrant**: See [vagrant/README.rst](vagrant/README.rst) for instructions
  ```bash
  cd vagrant && vagrant up
  ```

### Developer test prerequisites

The `zm-core` and `zm-backoffice` PHPUnit suites use in-memory SQLite databases
through Doctrine's `pdo_sqlite` driver. Enable this extension in the PHP CLI
environment where you run the tests. On Ubuntu with PHP 8.4, install it with:

```bash
sudo apt-get install php8.4-sqlite3
php8.4 -r 'if (!extension_loaded("pdo_sqlite")) { fwrite(STDERR, "Missing pdo_sqlite extension\n"); exit(1); } new PDO("sqlite::memory:"); echo "SQLite test driver ready\n";'
```

The PHP 8.4 Docker development image already includes `pdo_sqlite` through its
PHP base image. For container-based tests, run the driver check inside the test
container using `php`. Without `pdo_sqlite`, database-backed tests fail with
`could not find driver`. SQLite is a test dependency; the application uses
MariaDB/MySQL at runtime.


License
-------

This software is licensed under
[GNU Affero General Public License version 3](http://www.gnu.org/licenses/agpl-3.0.html)

- Copyright (C) 2016-2024 Luxembourg House of Cybersecurity
- Copyright (C) 2016-2024 Jérôme Lombardi - https://github.com/jerolomb
- Copyright (C) 2016-2024 Juan Rocha - https://github.com/jfrocha
- Copyright (C) 2017-2024 Cédric Bonhomme - https://www.cedricbonhomme.org
- Copyright (C) 2019-2024 Ruslan Baidan - https://github.com/ruslanbaidan
- Copyright (C) 2016-2017 Guillaume Lesniak
- Copyright (C) 2016-2017 Thomas Metois
- Copyright (C) 2016-2017 Jérôme De Almeida

For more information, [the list of authors and contributors](AUTHORS) is available.

Data provided with MONARC (threats, assets, vulnerabilities, standards,
etc.) are licensed under
[CC0 1.0 Universal (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/) -
Public Domain Dedication.
These objects are available through the
[MONARC Objects Sharing Plarform](https://objects.monarc.lu).
If a specific author wants to license an object under a different license,
a pull request can be requested.

## Server installation

See [Ubuntu 26.04 installation](INSTALL/INSTALL.ubuntu2604.md) for a standalone
installation. That guide also links to the separate FO/BO pair and Ansible
instructions.

## Released component assembly

The default Composer graph uses Packagist: `monarc/core v2.14.2` and
`monarc/backoffice v2.14.2`, with stable root requirements and a committed
lock. Both frontend modules (`ng-anr` and `ng-backoffice`) use the immutable commits
of `v2.14.3` recorded in `package.json`.

In a clean checkout with PHP >=8.4.28 <8.5, Node.js 16.x and gettext installed, run:

```bash
bash scripts/prepare-release.sh
```

This installs production PHP packages from the lock, verifies vendor sources and
PHP syntax, checks out the exact frontend commits, installs each frontend's npm
lock, creates module/resource links and compiles translations. It creates the
runtime cache/proxy directories but does not connect to a database or migrate it.
For an existing installation, preserve configuration and data, then run the normal
`scripts/upgrade-db.sh` against the intended local/upgrade environment before
runtime validation. Application publication and production upgrades are separate.

Build an assembled release image with:

```bash
docker build --pull -f Dockerfile.release -t monarc-backoffice:candidate .
```

`Dockerfile.release.dockerignore` includes the prepared vendor/frontend/assets
and excludes local configuration, Git metadata and runtime data. Static fonts
remain bundled. Release images default to `APP_ENV=production` and
`MONARC_PREPARED_RELEASE=1`; first boot uses the bundled dependencies. Development
images retain their normal setup behavior.

Explicit sibling-source development remains available through
`scripts/switch_repo_sources.sh local` (or `local-php`), and `remote` restores the
published PHP graph and pinned frontend commits. The local switch changes the
Composer manifest/lock; do not include that override in a release commit.
`COMPOSE_FILE` and `COMPOSE_PROJECT_NAME` can select the intended local stack.
