# RackChief

This repository runs the Backend and Frontend submodules together for development.

## Development

1. Clone with submodules: `git clone --recurse-submodules https://github.com/RackChief/RackChief.git`.
2. Copy `.env.example` to `.env` and fill in the hosted Supabase development `DATABASE_URL`, `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, and `SUPABASE_SECRET_KEY`. Keep `.env` local; it is ignored by Git.
3. Set `BACKEND_PORT` and `FRONTEND_PORT` if the defaults (3000 and 5173) are occupied. The browser uses the frontend origin; Vite proxies `/api` and `/mcp` to the backend container. Leave `VITE_API_URL` unset for normal Compose development.
4. Start both services: `docker compose -f docker-compose.dev.yml up --build`.

Open the frontend at `http://localhost:5173` (substitute your configured port). Only the frontend port is published to the host. The API is under `/api/v1`; backend health and OpenAPI are available inside Compose at `http://backend:3000/health` and `http://backend:3000/openapi.json` when using the default backend port.

Source files are mounted into each container. Backend `tsx watch` and frontend Vite reload as files change. Dependencies are installed from each submodule's `package-lock.json` and stored in Docker volumes. After a dependency file changes, rebuild the affected image, then recreate the dependency volumes so they contain the new install:

```sh
docker compose -f docker-compose.dev.yml build backend
docker compose -f docker-compose.dev.yml build frontend
docker compose -f docker-compose.dev.yml down -v
docker compose -f docker-compose.dev.yml up
```

`down -v` removes the two dependency volumes. It does not affect the hosted database.

Useful commands:

```sh
docker compose -f docker-compose.dev.yml logs -f backend
docker compose -f docker-compose.dev.yml logs -f frontend
docker compose -f docker-compose.dev.yml exec backend npm run db:generate
docker compose -f docker-compose.dev.yml exec backend npm run db:migrate
docker compose -f docker-compose.dev.yml down
```

Migrations are manual. PostgreSQL is hosted in the existing Supabase development project; Compose does not run a database.

## Nuxt V1 staging

The Nuxt 4 frontend is being built in `Frontend/nuxt` while the existing React app remains available. Run the Nuxt staging stack separately:

```sh
docker compose -f docker-compose.nuxt.dev.yml up --build
```

Open `http://localhost:5175`. The staging frontend proxies `/api/v1` and `/mcp` to the same private backend container. Stop the stack with `docker compose -f docker-compose.nuxt.dev.yml down`. Run `npm run typecheck` and `npm run build` from `Frontend/nuxt` for local checks.
