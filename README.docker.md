# Docker Development Environment for MONARC BackOffice

This guide explains how to set up a local development environment for MONARC BackOffice using Docker.

## Prerequisites

- Docker Engine 20.10 or later
- Docker Compose V2 (comes with Docker Desktop)
- At least 4GB of RAM available for Docker
- At least 10GB of free disk space

## Quick Start

### Option 1: Using the Helper Script (Recommended)

1. **Clone the repository** (if you haven't already):
   ```bash
   git clone https://github.com/monarc-project/MonarcAppBO
   cd MonarcAppBO
   ```

2. **Start the development environment**:
   ```bash
   ./docker-dev.sh start
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

| Service | Description | Port | Container Name |
|---------|-------------|------|----------------|
| monarc | Main BackOffice application (PHP/Apache) | 5002 | monarc-bo-app |
| db | MariaDB database | 3306 | monarc-bo-db |

## Development Workflow

### Helper Script Commands

The `docker-dev.sh` script provides convenient commands for managing the development environment:

```bash
./docker-dev.sh start         # Start all services
./docker-dev.sh stop          # Stop all services
./docker-dev.sh restart       # Restart all services
./docker-dev.sh logs          # View logs from all services
./docker-dev.sh logs-app      # View logs from MONARC application
./docker-dev.sh shell         # Open a shell in the MONARC container
./docker-dev.sh db            # Open MySQL client
./docker-dev.sh status        # Show status of all services
./docker-dev.sh reset         # Reset everything (removes all data)
```

### Live Code Editing

The application source code is mounted as a volume, so changes you make on your host machine will be immediately reflected in the container. After making changes:

1. **PHP/Backend changes**: Apache automatically reloads modified files
2. **Frontend changes**: You may need to rebuild the frontend:
   ```bash
   docker exec -it monarc-bo-app bash
   cd /var/www/html/monarc
   ./scripts/update-all.sh -d
   ```

### Accessing the Container

Using helper script:
```bash
./docker-dev.sh shell
```

Or directly with docker:
```bash
docker exec -it monarc-bo-app bash
```

### Database Access

Using helper script:
```bash
./docker-dev.sh db  # Connect to MariaDB
```

Or directly with docker:
```bash
# Connect to MariaDB
docker exec -it monarc-bo-db mysql -usqlmonarcuser -psqlmonarcuser monarc_common
```

### Viewing Logs

Using helper script:
```bash
./docker-dev.sh logs          # All services
./docker-dev.sh logs-app      # MONARC application only
```

Or directly with docker compose:
```bash
# View logs for all services
docker compose -f docker-compose.dev.yml logs -f

# View logs for a specific service
docker compose -f docker-compose.dev.yml logs -f monarc
```

### Restarting Services

Using helper script:
```bash
./docker-dev.sh restart  # Restart all services
```

Or directly with docker compose:
```bash
# Restart all services
docker compose -f docker-compose.dev.yml restart

# Restart a specific service
docker compose -f docker-compose.dev.yml restart monarc
```

### Stopping the Environment

Using helper script:
```bash
./docker-dev.sh stop   # Stop all services (keeps data)
./docker-dev.sh reset  # Stop and remove everything including data
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

### Resetting the Database

To completely reset the databases:
```bash
docker compose -f docker-compose.dev.yml down -v
docker compose -f docker-compose.dev.yml up --build
```

### Installing New PHP Dependencies

```bash
docker exec -it monarc-bo-app bash
composer require package/name
```

### Installing New Node Dependencies

```bash
docker exec -it monarc-bo-app bash
cd node_modules/ng_backoffice  # or ng_anr
npm install package-name
```

### Running Database Migrations

```bash
docker exec -it monarc-bo-app bash
php ./vendor/robmorgan/phinx/bin/phinx migrate -c ./module/Monarc/BackOffice/migrations/phinx.php
```

### Rebuilding Frontend

```bash
docker exec -it monarc-bo-app bash
cd /var/www/html/monarc
./scripts/update-all.sh -d
```

## Debugging

### Xdebug Configuration

Xdebug is pre-configured in the development environment. To use it:

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
docker compose -f docker-compose.dev.yml ps monarc
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
docker exec -it monarc-bo-app bash
chown -R www-data:www-data /var/www/html/monarc/data
chmod -R 775 /var/www/html/monarc/data
```

### Database Connection Issues

Check if the database is healthy:
```bash
docker compose -f docker-compose.dev.yml ps db
```

If needed, restart the database:
```bash
docker compose -f docker-compose.dev.yml restart db
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

## Environment Variables Reference

All environment variables are defined in the `.env` file:

| Variable | Description | Default |
|----------|-------------|---------|
| `DBPASSWORD_ADMIN` | MariaDB root password | `root` |
| `DBNAME_COMMON` | Common database name | `monarc_common` |
| `DBNAME_MASTER` | Master database name | `monarc_master` |
| `DBUSER_MONARC` | Database user | `sqlmonarcuser` |
| `DBPASSWORD_MONARC` | Database password | `sqlmonarcuser` |

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
