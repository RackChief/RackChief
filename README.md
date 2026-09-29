# RackChief

This repository runs the Backend and Frontend submodules together for development.

## Development

1. Clone with submodules: `git clone --recurse-submodules https://github.com/RackChief/RackChief.git`.
2. Copy `.env.example` to `.env` and fill in the hosted Supabase development `DATABASE_URL`, `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, and `SUPABASE_SECRET_KEY`. Keep `.env` local; it is ignored by Git.
3. Set `BACKEND_PORT` and `FRONTEND_PORT` if the defaults (3000 and 5173) are occupied. Set `VITE_API_URL` to `http://localhost:<BACKEND_PORT>` when changing the backend port. This URL is used by the browser, so do not use Docker's `backend` hostname.
4. Start both services: `docker compose -f docker-compose.dev.yml up --build`.

Open the frontend at `http://localhost:5173` and the backend health endpoint at `http://localhost:3000/health` (substitute your configured ports). The API is under `/api/v1`; the backend also serves `/docs`.

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
