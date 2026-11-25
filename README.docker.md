# Docker Development Environment for MONARC BackOffice

This guide explains how to set up a local development environment for MONARC BackOffice using Docker.

## Prerequisites

- Docker Engine 20.10 or later
- Docker Compose V2 (comes with Docker Desktop)
- At least 4GB of RAM available for Docker
- At least 10GB of free disk space
- A sibling checkout of `zm-core`, `zm-backoffice`, `ng-anr`, and `ng-backoffice`

The development Compose configuration bind-mounts those four repositories. Keep
them beside `MonarcAppBO`; Docker is configured to fail rather than silently
create empty directories when one is missing:

```text
parent-directory/
├── MonarcAppBO/
├── zm-core/
├── zm-backoffice/
├── ng-anr/
└── ng-backoffice/
```

## Quick Start

### Option 1: Using the Makefile (Recommended)

1. **Clone the repository** (if you haven't already):
   ```bash
   git clone https://github.com/monarc-project/MonarcAppBO
   cd MonarcAppBO
   ```

2. **Start the development environment**:
   ```bash
   make start
   ```
   
   This will automatically:
   - Create `.env` file from `.env.dev` if it doesn't exist
   - Build and start all services
   - Display access URLs
   
   The first run will take several minutes as it:
   - Builds the Docker images
   - Installs all dependencies (PHP, Node.js)
   - Clones frontend repositories
   - Initializes databases
   - Builds the frontend

3. **Access the application**:
   - MONARC BackOffice: http://localhost:5002

### Option 2: Using Docker Compose Directly

1. **Clone the repository** (if you haven't already):
   ```bash
   git clone https://github.com/monarc-project/MonarcAppBO
   cd MonarcAppBO
   ```

2. **Copy the environment file**:
   ```bash
   cp .env.dev .env
   ```

3. **Customize environment variables** (optional):
   Edit `.env` file to change default passwords and configuration.

4. **Start the development environment**:
   ```bash
   docker compose -f docker-compose.dev.yml up --build
   ```

5. **Access the application**:
   - MONARC BackOffice: http://localhost:5002

## Services

The development environment includes the following services:

| Service | Description | Host port | Container port | Override |
|---------|-------------|-----------|----------------|----------|
| monarcboapp | Main BackOffice application (PHP/Apache) | 5002 | 80 | `MONARC_BO_APP_PORT` |
| bodb | MariaDB database | 3308 | 3306 | `MONARC_BO_DB_PORT` |

## Development Workflow

### Makefile Commands

The Makefile provides convenient commands for managing the development environment.
Use `ENV=<name>` to select `docker-compose.<name>.yml` (default: `dev`).

```bash
make start         # Start all services
make stop          # Stop all services
make restart       # Restart all services
make logs          # View logs from all services
make logs-app      # View logs from MONARC application
make shell         # Open a shell in the MONARC container
make db            # Open MySQL client
make status        # Show status of all services
make reset         # Reset everything (removes all data)
```

### Live Code Editing

Run frontend installation and updates inside the container, which provides
Node.js 16.x for the locked frontend dependencies:

```bash
make shell
# Inside the container:
./scripts/update-all.sh
```

Host builds also require Node.js 16.x. On Apple Silicon, use an ARM64 Node
runtime with ARM64 developer tools. Dependencies containing native binaries
must be installed again when switching between the host and container.

The application source code is mounted as a volume, so changes you make on your host machine will be immediately reflected in the container. After making changes:

1. **PHP/Backend changes**: Apache automatically reloads modified files
2. **Frontend changes**: You may need to rebuild the frontend:
   ```bash
   docker compose -f docker-compose.dev.yml exec monarcboapp bash
   cd /var/www/html/monarc
   ./scripts/update-all.sh
   ```

### Developing sibling repositories

The sibling repositories are mounted into the container but are not used until
you switch the application to local sources. This preserves the normal
release-package startup path while making changes in all four sibling
repositories available for development.

```bash
make local-repos
```

This verifies the checkout layout, starts the environment, makes Composer use
symlinked `zm-core` and `zm-backoffice` packages, and links the two AngularJS
repositories into `node_modules`. It then rebuilds the linked frontend assets.

Use these commands to inspect or revert the source mode:

```bash
make repo-status
make remote-repos
```

`make remote-repos` restores the release Composer packages and GitHub frontend
clones. Switching source mode updates Composer metadata and dependencies, so
review the `MonarcAppBO` working tree before committing.

### Accessing the Container

Using Makefile:
```bash
make shell
```

Or directly with docker:
```bash
docker compose -f docker-compose.dev.yml exec monarcboapp bash
```

### Database Access

Using Makefile:
```bash
make db  # Connect to MariaDB
```

Or directly with docker:
```bash
# Connect to MariaDB
docker compose -f docker-compose.dev.yml exec bodb sh -c 'MYSQL_PWD="$MYSQL_PASSWORD" exec mysql -u"$MYSQL_USER" "$MYSQL_DATABASE"'
```

### Viewing Logs

Using Makefile:
```bash
make logs          # All services
make logs-app      # MONARC application only
```

Or directly with docker compose:
```bash
# View logs for all services
docker compose -f docker-compose.dev.yml logs -f

# View logs for a specific service
docker compose -f docker-compose.dev.yml logs -f monarcboapp
```

### Restarting Services

Using Makefile:
```bash
make restart  # Restart all services
```

Or directly with docker compose:
```bash
# Restart all services
docker compose -f docker-compose.dev.yml restart

# Restart a specific service
docker compose -f docker-compose.dev.yml restart monarcboapp
```

### Stopping the Environment

Using Makefile:
```bash
make stop   # Stop all services (keeps data)
make reset  # Stop and remove everything including data
```

Or directly with docker compose:
```bash
# Stop all services (keeps data)
docker compose -f docker-compose.dev.yml stop

# Stop and remove containers (keeps volumes/data)
docker compose -f docker-compose.dev.yml down

# Stop and remove everything including data
docker compose -f docker-compose.dev.yml down -v
```

## Common Tasks

### Shared Docker Network

To connect FrontOffice and BackOffice containers, use a shared external network:

1. Create the network once: `docker network create monarc-network`
2. Set `MONARC_NETWORK_NAME=monarc-network` in both projects' `.env` files.
3. Ensure the BackOffice compose file also uses the same external network name.

### Resetting the Database

To completely reset the databases:
```bash
docker compose -f docker-compose.dev.yml down -v
docker compose -f docker-compose.dev.yml up --build
```

### Installing New PHP Dependencies

```bash
docker compose -f docker-compose.dev.yml exec monarcboapp bash
composer require package/name
```

### Installing New Node Dependencies

```bash
docker compose -f docker-compose.dev.yml exec monarcboapp bash
cd node_modules/ng_backoffice  # or ng_anr
npm install package-name
```

### Running Database Migrations

```bash
docker compose -f docker-compose.dev.yml exec monarcboapp bash
php ./vendor/robmorgan/phinx/bin/phinx migrate -c ./module/Monarc/BackOffice/migrations/phinx.php
```

### Rebuilding Frontend

```bash
docker compose -f docker-compose.dev.yml exec monarcboapp bash
cd /var/www/html/monarc
./scripts/update-all.sh
```

## Debugging

### Xdebug Configuration

Xdebug is enabled by default in the development image. To disable it, set
`XDEBUG_ENABLED=0` in `.env` and rebuild the image (for example, `make start`).
You can also tune the connection behavior via `.env`:
`XDEBUG_START_WITH_REQUEST`, `XDEBUG_CLIENT_HOST`, and `XDEBUG_CLIENT_PORT`.

When enabled, Xdebug is pre-configured. To use it:

1. Configure your IDE to listen on port 9003
2. Set the IDE key to `IDEKEY`
3. Start debugging in your IDE
4. Trigger a request to the application

For PhpStorm:
- Go to Settings → PHP → Debug
- Set Xdebug port to 9003
- Enable "Can accept external connections"
- Set the path mappings: `/var/www/html/monarc` → your local project path

### Checking Service Health

```bash
# Check if all services are running
docker compose -f docker-compose.dev.yml ps

# Check specific service health
docker compose -f docker-compose.dev.yml ps monarcboapp
```

## Troubleshooting

### Port Conflicts

If you get port conflicts, you can change the ports in the `docker-compose.dev.yml` file:
```yaml
ports:
  - "5002:80"  # Change 5002 to another available port
```

### Permission Issues

If you encounter permission issues with mounted volumes:
```bash
docker compose -f docker-compose.dev.yml exec monarcboapp bash
chown -R www-data:www-data /var/www/html/monarc/data
chmod -R 775 /var/www/html/monarc/data
```

### Database Connection Issues

Check if the database is healthy:
```bash
docker compose -f docker-compose.dev.yml ps bodb
```

If needed, restart the database:
```bash
docker compose -f docker-compose.dev.yml restart bodb
```

### Rebuilding from Scratch

If something goes wrong and you want to start fresh:
```bash
# Stop everything
docker compose -f docker-compose.dev.yml down -v

# Remove all related containers, images, and volumes
docker system prune -a

# Rebuild and start
docker compose -f docker-compose.dev.yml up --build
```

## Performance Optimization

For better performance on macOS and Windows:

1. **Use Docker volume mounts for dependencies**: The compose file already uses named volumes for `vendor` and `node_modules` to improve performance.

2. **Allocate more resources**: In Docker Desktop settings, increase:
   - CPUs: 4 or more
   - Memory: 4GB or more
   - Swap: 1GB or more

3. **Enable caching**: The Dockerfile uses apt cache and composer optimizations.

## Comparison with Vagrant

| Feature | Docker | Vagrant |
|---------|--------|---------|
| Startup time | Fast (~2-3 min) | Slow (~10-15 min) |
| Resource usage | Lower | Higher |
| Isolation | Container-level | VM-level |
| Portability | Excellent | Good |
| Live code reload | Yes | Yes |
| Learning curve | Moderate | Low |

### Public URL for password-reset links

`PUBLIC_HOST` is the externally reachable absolute http(s) URL for this instance,
including any public port and installation path. Development defaults to
`http://localhost:5002` and follows `MONARC_BO_APP_PORT` in `.env.dev`.
Override it for a reverse proxy or server, for example
`PUBLIC_HOST=https://monarc.example.org`. Credentials, query strings and URL
fragments are rejected. The value is never taken from the request `Host` header.

Fresh Docker initialization requires a valid `PUBLIC_HOST` before installing
packages or changing databases. Release images have no implicit public URL;
provide it explicitly. Existing initialized containers keep their existing
`config/autoload/local.php`: add/update its top-level `publicHost` manually,
clear that application's generated configuration cache and restart it. Changing
`.env` alone does not rewrite an initialized application's local configuration.

## Environment Variables Reference

All environment variables are defined in the `.env` file:

| Variable | Description | Default |
|----------|-------------|---------|
| `DBPASSWORD_ADMIN` | MariaDB root password | `root` |
| `DBNAME_COMMON` | Common database name | `monarc_common` |
| `DBNAME_MASTER` | Master database name | `monarc_master` |
| `DBUSER_MONARC` | Database user | `sqlmonarcuser` |
| `DBPASSWORD_MONARC` | Database password | `sqlmonarcuser` |
| `PUBLIC_HOST` | Public base URL for password-reset links; required on first initialization | `http://localhost:5002` (dev) |
| `XDEBUG_ENABLED` | Enable Xdebug in the build (`1/0`, `true/false`, `yes/no`) | `1` |
| `XDEBUG_MODE` | Xdebug modes (`debug`, `develop`, etc.) | `debug` |
| `XDEBUG_START_WITH_REQUEST` | Start mode (`trigger` or `yes`) | `trigger` |
| `XDEBUG_CLIENT_HOST` | Host IDE address | `host.docker.internal` |
| `XDEBUG_CLIENT_PORT` | IDE port | `9003` |
| `XDEBUG_IDEKEY` | IDE key | `IDEKEY` |
| `XDEBUG_DISCOVER_CLIENT_HOST` | Auto-detect client host (`1/0`) | `0` |

## Security Notes

⚠️ **Important**: The default credentials provided are for development only. Never use these in production!

For production deployments:
1. Change all default passwords
2. Use proper SSL/TLS certificates
3. Follow security best practices

## Additional Resources

- [MONARC Website](https://www.monarc.lu)
- [MONARC Documentation](https://www.monarc.lu/documentation)
- [GitHub Repository](https://github.com/monarc-project/MonarcAppBO)
- [MonarcAppFO (FrontOffice)](https://github.com/monarc-project/MonarcAppFO)

## Getting Help

If you encounter issues:

1. Check the [troubleshooting section](#troubleshooting)
2. Review the logs: `docker compose -f docker-compose.dev.yml logs`
3. Open an issue on [GitHub](https://github.com/monarc-project/MonarcAppBO/issues)
4. Join the MONARC community discussions
