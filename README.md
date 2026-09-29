# RackChief

This repository runs the RackChief Backend and Nuxt Frontend submodules together for development.

## Development

1. Clone with submodules: `git clone --recurse-submodules https://github.com/RackChief/RackChief.git`.
2. Copy `.env.example` to `.env` and fill in the hosted Supabase development `DATABASE_URL`, `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, and `SUPABASE_SECRET_KEY`. Keep `.env` local; it is ignored by Git.
3. Set `BACKEND_PORT` and `FRONTEND_PORT` if the defaults (3000 and 5173) are occupied. Leave `NUXT_PUBLIC_API_BASE` unset for normal same-origin access.
4. Start both services: `docker compose -f docker-compose.dev.yml up --build`.

Open Nuxt at `http://localhost:5173` (substitute your configured frontend port). Only the frontend port is published to the host. Nuxt proxies `/api/v1/*` and `/mcp` to the private backend container. Supabase is used for authentication; all RackChief application data comes through the backend API.

Source files are mounted into the containers. Backend `tsx watch` and Nuxt reload as files change. Dependencies come from `Backend/package-lock.json` and `Frontend/nuxt/package-lock.json` and are stored in Docker volumes. After a dependency file changes, rebuild the affected image and recreate the dependency volumes:

```sh
docker compose -f docker-compose.dev.yml build backend frontend
docker compose -f docker-compose.dev.yml down -v
docker compose -f docker-compose.dev.yml up
```

`down -v` removes dependency volumes. It does not affect the hosted database or the device-image cache, which is bind-mounted at `.data/device-images/`.

Useful commands:

```sh
docker compose -f docker-compose.dev.yml logs -f backend
docker compose -f docker-compose.dev.yml logs -f frontend
docker compose -f docker-compose.dev.yml exec backend npm run db:generate
docker compose -f docker-compose.dev.yml exec backend npm run db:migrate
docker compose -f docker-compose.dev.yml down
```

Migrations are manual. PostgreSQL is hosted in the existing Supabase development project; Compose does not run a database. Backend health and OpenAPI are available inside Compose at `http://backend:3000/health` and `http://backend:3000/openapi.json` with the default backend port.

## Device images

The backend fetches matching front/rear elevations from the NetBox Community Device Type Library on first use and caches them under `.data/device-images/netbox/`. Custom per-asset overrides are stored under `.data/device-images/custom/`. Back up this directory if custom images must survive a host replacement. Image reads use expiring URLs issued after authentication; Nuxt Image renders them and falls back to a generic faceplate when no image is available.

See [Frontend/README.md](Frontend/README.md) for Nuxt configuration and routes, and [FRONTEND_V1_PROGRESS.md](FRONTEND_V1_PROGRESS.md) for the remaining V1 review work.
