# RackChief

RackChief is a self-hostable homelab inventory and planning application. A deployment requires PostgreSQL, the RackChief backend, and the Nuxt frontend; no cloud service is required.

Copy `.env.example` to `.env`, replace the example PostgreSQL password and auth secret, and set `BETTER_AUTH_URL` for your deployment. The backend builds its PostgreSQL URL from `PG_USER`, `PG_PASS`, `PG_HOST`, `PG_DB_NAME`, and `PG_PORT`; it applies pending migrations on startup.

For development testing with PostgreSQL in Docker, start the optional database and wait for its health check before starting the app. `PG_HOST=db` selects the Docker service for these commands without changing your saved production host:

```sh
PG_HOST=db docker compose -f docker-compose.yml -f docker.postgres.yml up -d db --wait
PG_HOST=db docker compose -f docker-compose.yml -f docker.postgres.yml up --build
```

For an external production PostgreSQL instance, set `PG_HOST` to its reachable host and set the other `PG_*` values to that instance's credentials, database, and port. Set `PG_SSLMODE` if it requires TLS. Run `docker compose up --build`; the root Compose file includes only `docker.backend.yml` and `docker.frontend.yml`, so it does not start the development database. `localhost` inside the backend container refers to the container itself.

Open `http://localhost:5173`, create the first administrator, and sign in. Better Auth provides local email/password authentication with secure HttpOnly session cookies. RackChief application data is accessed through the backend and Drizzle/PostgreSQL. MCP remains a separate, optional RackChief-token endpoint.
