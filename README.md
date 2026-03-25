# GunBound Infrastructure

Docker Compose orchestration, database initialization scripts, and migrations for the GunBound project.

## Services

| Service | Image | Port |
|---------|-------|------|
| PostgreSQL | `postgres:16-alpine` | 5432 |
| Redis | `redis:7-alpine` | 6379 |
| Backend API | `youruser/gunbound-backend:latest` | 5000 |
| Frontend | `youruser/gunbound-frontend:latest` | 4200 |
| pgAdmin | `dpage/pgadmin4` | 5050 |

## Getting Started

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)

### Running the full stack

```bash
# Copy and fill in the env file
cp .env.example .env

# Start all services
docker compose up -d
```

### Stopping

```bash
docker compose down
```

### Resetting the database

```bash
docker compose down -v   # removes volumes
docker compose up -d
```

## DB Migrations

Migration scripts live in `migrations/`. Run them in order against the PostgreSQL instance:

```bash
psql -h localhost -U postgres -d gunbound_db -f migrations/migration_add_gamemode_chat.sql
```

## Seed Data

```bash
psql -h localhost -U postgres -d gunbound_db -f seed_gamemodes.sql
```

## CI/CD

On every push to `main`, GitHub Actions pulls the latest images from Docker Hub and redeploys.

Requires the following repository secrets:
- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`

## Related Repos

| Repo | Description |
|------|-------------|
| [gunbound-backend](https://github.com/alvaroMarcani/gunbound-backend) | .NET 9 API & SignalR backend |
| [gunbound-frontend](https://github.com/alvaroMarcani/gunbound-frontend) | Angular client app |
