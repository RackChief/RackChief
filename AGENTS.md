# RackChief workspace guidance

This repository composes the RackChief application.

## Repositories

- `Backend/` contains the Express/TypeScript API.
- `Frontend/` contains the web UI.
- The root repository contains deployment/orchestration files.

## When working on the frontend

Before implementing API-backed features:

1. Inspect the relevant backend route in `Backend/src/modules/`.
2. Inspect the corresponding Zod/OpenAPI schema.
3. Prefer the backend contract over assumptions.
4. Do not duplicate backend enums or response shapes unless needed.
5. If the backend API is missing something required by the frontend, call it out before inventing a workaround.

The backend currently exposes OpenAPI through its generated spec and should be treated as the source of truth for API behavior.

## When changing both frontend and backend

Keep changes scoped and compatible.
Update OpenAPI whenever backend routes or schemas change.
