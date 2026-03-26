# Boomy Infrastructure

Docker Compose orchestration, database init scripts, and migrations for the Boomy project.

## Repository Structure

```
boomy-infrastructure/
├── docker-compose.yml              # Full stack definition
├── init.sql                        # DB user & database bootstrap (runs once on first start)
├── seed_gamemodes.sql              # Initial game mode seed data
├── migrations/
│   └── migration_add_gamemode_chat.sql   # Adds GameModes & ChatMessages tables
└── .github/
    └── workflows/
        └── deploy.yml              # Auto-deploy on push to main
```

## Services

| Service | Image | Port | Credentials |
|---------|-------|------|-------------|
| PostgreSQL | `postgres:16-alpine` | 5432 | `postgres` / `postgres` |
| Redis | `redis:7-alpine` | 6379 | — |
| Backend API | `alvaroMarcani/boomy-backend:latest` | 5000 | — |
| Frontend | `alvaroMarcani/boomy-frontend:latest` | 4200 | — |
| pgAdmin | `dpage/pgadmin4:latest` | 5050 | `admin@boomy.com` / `admin123` |

All services run on the `boomy_network` bridge network.

## Getting Started

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (includes Docker Compose)

### 1 — Start the full stack

```bash
docker compose up -d
```

On first run `init.sql` executes automatically inside the PostgreSQL container and creates:
- The `boomy_user` role
- The `boomy_db` database

The backend seeds the four default game modes on startup.

### 2 — Verify everything is running

```bash
docker compose ps
```

| URL | Service |
|-----|---------|
| http://localhost:4200 | Frontend |
| http://localhost:5000/swagger | Backend API / Swagger |
| http://localhost:5050 | pgAdmin |

### 3 — Connect pgAdmin to the database

Open http://localhost:5050 and add a server with:

| Field | Value |
|-------|-------|
| Host | `postgres` |
| Port | `5432` |
| Database | `boomy_db` |
| Username | `boomy_user` |
| Password | `Boomy123!@#` |

### Stopping

```bash
docker compose down
```

### Resetting the database (wipes all data)

```bash
docker compose down -v   # -v removes named volumes
docker compose up -d
```

## Running DB Migrations

Migrations live in `migrations/`. Apply them in order while the stack is running:

```bash
# Example: apply the GameModes + ChatMessages migration
docker exec -i boomy_postgres psql -U boomy_user -d boomy_db \
  < migrations/migration_add_gamemode_chat.sql
```

Or directly from the host if you have `psql` installed:

```bash
psql -h localhost -U boomy_user -d boomy_db \
  -f migrations/migration_add_gamemode_chat.sql
```

## Seed Data

```bash
psql -h localhost -U boomy_user -d boomy_db -f seed_gamemodes.sql
```

## CI/CD

`deploy.yml` runs on every push to `main`:

1. SSH into the server
2. Pull latest Docker images (`docker compose pull`)
3. Redeploy (`docker compose up -d --remove-orphans`)

**Required repository secrets:**

| Secret | Description |
|--------|-------------|
| `DOCKER_USERNAME` | Docker Hub username |
| `DOCKER_PASSWORD` | Docker Hub password or access token |

## Related Repos

| Repo | Description |
|------|-------------|
| [boomy-backend](https://github.com/alvaroMarcani/boomy-backend) | .NET 9 API & SignalR backend |
| [boomy-frontend](https://github.com/alvaroMarcani/boomy-frontend) | Angular 19 client |
| [boomy-db-scripts](https://github.com/alvaroMarcani/boomy-db-scripts) | Standalone DB init & seed scripts |

