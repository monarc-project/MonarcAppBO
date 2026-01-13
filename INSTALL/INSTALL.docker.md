# Docker Installation Guide for MONARC BackOffice

This document provides installation instructions for setting up MONARC BackOffice using Docker for development purposes.

## Quick Installation

```bash
# Clone the repository
git clone https://github.com/monarc-project/MonarcAppBO
cd MonarcAppBO

# Start with the helper script (recommended)
./docker-dev.sh start

# Or use docker-compose directly
cp .env.dev .env
docker compose -f docker-compose.dev.yml up -d --build
```

## What Gets Installed

The Docker setup includes:

1. **MONARC BackOffice Application**
   - Ubuntu 22.04 base
   - PHP 8.1 with all required extensions
   - Apache web server
   - Composer for PHP dependencies
   - Node.js for frontend
   - All MONARC modules and dependencies

2. **MariaDB 10.11**
   - Database for MONARC application data
   - Pre-configured with proper character sets

## First Time Setup

When you start the environment for the first time:

1. Docker images will be built (5-10 minutes)
2. Dependencies will be installed automatically
3. Databases will be created and initialized
4. Frontend repositories will be cloned and built

## Access URLs

After startup, access the application at:

- **MONARC BackOffice**: http://localhost:5002

## Default Credentials

The BackOffice uses the same authentication system as your configured instances.
You'll need to configure user accounts through the application.

⚠️ **Security Warning**: Change these credentials before deploying to production!

## System Requirements

- Docker Engine 20.10 or later
- Docker Compose V2
- At least 4GB RAM available for Docker
- At least 10GB free disk space
- Linux, macOS, or Windows with WSL2

## Configuration

Environment variables are defined in the `.env` file (copied from `.env.dev`):

- Database credentials
- Service ports

You can customize these before starting the environment.

## Troubleshooting

### Port Conflicts

If port 5002 or 3306 is already in use:

1. Edit `docker-compose.dev.yml`
2. Change the host port (left side of the port mapping)
3. Example: Change `"5002:80"` to `"8002:80"`

### Permission Issues

If you encounter permission errors:

```bash
docker exec -it monarc-bo-app bash
chown -R www-data:www-data /var/www/html/monarc/data
chmod -R 775 /var/www/html/monarc/data
```

### Service Not Starting

Check the logs:

```bash
./docker-dev.sh logs
# or
docker compose -f docker-compose.dev.yml logs
```

### Reset Everything

To start completely fresh:

```bash
./docker-dev.sh reset
# or
docker compose -f docker-compose.dev.yml down -v
```

## Common Tasks

### View Logs
```bash
./docker-dev.sh logs
```

### Access Container Shell
```bash
./docker-dev.sh shell
```

### Access Database
```bash
./docker-dev.sh db
```

### Stop Services
```bash
./docker-dev.sh stop
```

### Restart Services
```bash
./docker-dev.sh restart
```

## Comparison with Other Installation Methods

| Method | Complexity | Time | Best For |
|--------|-----------|------|----------|
| Docker | Low | Fast (2-5 min startup) | Development |
| Vagrant | Medium | Slow (10-15 min startup) | Development |
| Manual | High | Slow (30+ min) | Production |
| VM | Low | Medium | Testing |

## Next Steps

After installation:

1. Read the [full Docker documentation](README.docker.md)
2. Review the [MONARC documentation](https://www.monarc.lu/documentation)
3. Configure your BackOffice instances
4. Start developing!

## Getting Help

- **Documentation**: [README.docker.md](README.docker.md)
- **MONARC Website**: https://www.monarc.lu
- **GitHub Issues**: https://github.com/monarc-project/MonarcAppBO/issues
- **Community**: https://www.monarc.lu/community

## License

This project is licensed under the GNU Affero General Public License version 3.
See [LICENSE](LICENSE) for details.
