# RackChief

RackChief is a self-hostable homelab inventory and planning application. A deployment requires PostgreSQL, the RackChief backend, and the Nuxt frontend; no cloud service is required.

Copy `.env.example` to `.env` and set `DATABASE_URL`, `BETTER_AUTH_SECRET` (at least 32 random characters), and `BETTER_AUTH_URL`. Apply backend migrations with `cd Backend && npm run db:migrate`, then start the Compose stack with `docker compose -f docker-compose.dev.yml up --build`.

Open `http://localhost:5173`, create the first administrator, and sign in. Better Auth provides local email/password authentication with secure HttpOnly session cookies. RackChief application data is accessed through the backend and Drizzle/PostgreSQL. MCP remains a separate, optional RackChief-token endpoint.
