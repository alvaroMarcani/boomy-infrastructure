# boomy-infrastructure

[![Deploy](https://github.com/alvaroMarcani/boomy-infrastructure/actions/workflows/deploy.yml/badge.svg)](https://github.com/alvaroMarcani/boomy-infrastructure/actions/workflows/deploy.yml)
[![Docker Compose](https://img.shields.io/badge/Docker-Compose-2496ED)](https://docs.docker.com/compose/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Docker Compose stack, database bootstrap scripts, and SQL migrations for the Boomy project.

---

## Table of Contents

- [Services](#services)
- [Getting Started](#getting-started)
- [Applying Migrations](#applying-migrations)
- [CI/CD](#cicd)
- [Repository Structure](#repository-structure)
- [Contributing](#contributing)

---

## Services

| Service | Image | Local Port |
|---------|-------|-----------|
| PostgreSQL | `postgres:16-alpine` | 5432 |
| Redis | `redis:7-alpine` | 6379 |
| Backend API | `alvaroMarcani/boomy-backend:latest` | 5000 |
| Frontend | `alvaroMarcani/boomy-frontend:latest` | 4200 |
| pgAdmin | `dpage/pgadmin4:latest` | 5050 |

All services communicate over the `boomy_network` bridge network.

---

## Getting Started

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (includes Docker Compose)

### Start the full stack

```bash
docker compose up -d
```

On first run, `init.sql` creates the `boomy_user` role and the `boomy_db` database automatically inside the PostgreSQL container. Game modes are seeded by the backend on startup.

### Verify services are healthy

```bash
docker compose ps
```

| URL | Service |
|-----|---------|
| http://localhost:4200 | Frontend |
| http://localhost:5000/swagger | Backend / Swagger UI |
| http://localhost:5050 | pgAdmin |

### Connect pgAdmin to the database

Open **http://localhost:5050**, log in with `admin@boomy.com` / `admin123`, and register a new server:

| Field | Value |
|-------|-------|
| Host | `postgres` |
| Port | `5432` |
| Database | `boomy_db` |
| Username | `boomy_user` |
| Password | `Boomy123!@#` |

### Stop the stack

```bash
docker compose down          # keep volumes (data is preserved)
docker compose down -v       # remove volumes (full reset)
```

---

## Applying Migrations

Migration scripts live in `migrations/`. Apply them while the stack is running.

**Via Docker (no local psql required):**

```bash
docker exec -i boomy_postgres psql -U boomy_user -d boomy_db \
  < migrations/migration_add_gamemode_chat.sql
```

**Via local psql:**

```bash
psql -h localhost -U boomy_user -d boomy_db \
  -f migrations/migration_add_gamemode_chat.sql
```

---

## CI/CD

`deploy.yml` triggers on every push to `main`:

1. Pull the latest images from Docker Hub
2. Run `docker compose up -d --remove-orphans`

**Required repository secrets:**

| Secret | Description |
|--------|-------------|
| `DOCKER_USERNAME` | Docker Hub username |
| `DOCKER_PASSWORD` | Docker Hub password or access token |

---

## Repository Structure

```
boomy-infrastructure/
+-- docker-compose.yml                        # Full stack definition
+-- init.sql                                  # Bootstraps boomy_user and boomy_db
+-- seed_gamemodes.sql                        # Initial game mode seed data
+-- migrations/
|   +-- migration_add_gamemode_chat.sql       # Adds GameModes & ChatMessages tables
+-- .github/workflows/
    +-- deploy.yml                            # Automated deploy on push to main
```

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m "feat: add your feature"`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a pull request

---

## Related Repositories

| Repository | Description |
|---|---|
| [boomy-backend](https://github.com/alvaroMarcani/boomy-backend) | .NET 9 REST API + SignalR |
| [boomy-frontend](https://github.com/alvaroMarcani/boomy-frontend) | Angular 19 client |
| [boomy-db-scripts](https://github.com/alvaroMarcani/boomy-db-scripts) | Standalone SQL scripts |
