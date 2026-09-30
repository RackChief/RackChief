# Frontend V1 work state — 2026-09-29

The scope is [Frontend/RackChief-Frontend-V1-Goals.md](Frontend/RackChief-Frontend-V1-Goals.md). The Nuxt implementation is the default development frontend. **V1 is not yet verified or tagged.** The user requested no further frontend checks and will inspect the application manually.

## Current implementation

- `Frontend/nuxt` is the sole tracked frontend application. It uses Nuxt 4, Vue 3, TypeScript, Nuxt UI, Nuxt Icon, and Nuxt Image. Authentication uses Better Auth session cookies through the backend; RackChief data comes from the backend through a shared `/api/v1` client. The stale tracked React/Vite source, dependencies, assets, and configuration were removed after explicit user approval.
- Root `docker-compose.dev.yml` now runs Nuxt on `FRONTEND_PORT` (default 5173) with same-origin `/api/v1` and `/mcp` proxying. The redundant Nuxt staging Compose file was removed. Root and Frontend READMEs describe the current setup.
- Nuxt routes cover login, assets and asset detail, components and spares, locations, racks and placement, projects, MCP settings, and About/Attributions. Asset detail includes hardware, network interfaces/IPs/ports/connections, rack placement, relationships, project links, and device imagery.
- The backend lazily retrieves elevation images from the NetBox Community Device Type Library, caches them under `.data/device-images/netbox/`, and supports per-asset PNG/JPEG/WebP overrides under `.data/device-images/custom/`. Signed image URLs render through Nuxt Image; missing images use a generic labeled faceplate. The bind mount preserves cache and overrides across container recreation.
- Optional Nuxt select choices now use nonempty UI markers mapped to nullable backend fields. Missing Better Auth sessions redirect to login. Location editing excludes descendant parent choices. Switching a project item from purchase to work clears purchase-only fields. Device-image lookup has a bounded upstream budget and temporary retry pause after errors; deleting an asset removes its custom image files.

## Evidence gathered before the no-check instruction

- Backend build, Nuxt typecheck/build, and the old React build passed at earlier checkpoints. The current source and Compose migration have **not** been built or typechecked.
- Authenticated Chromium loaded the main Nuxt pages and a known Dell asset with front/rear images. At a 390 px viewport the rack page no longer overflowed. A disposable asset was created, opened, edited, archived, restored, and deleted. Disposable locations, spare components, racks, and rack placements passed create/edit/delete flows with no page errors; test records were cleaned up.
- The authenticated signed-image URL issuer returned 200, direct and IPX image reads returned 200, an unsigned image URL returned 404, and a tampered signature returned 401. A cached default image survived a full Compose down/up without its cache file being rewritten. A custom override was uploaded, read after backend restart, and removed. These checks preceded the latest image service edits.
- The development database was not reset. The default image cache remains in ignored `.data/device-images/`. Root `assets/` is user-provided untracked brand material and was left untouched.

## Manual V1 review still needed

1. Start the default stack with `docker compose -f docker-compose.dev.yml up --build` and open the Nuxt app at `http://localhost:5173` (or the configured port). Confirm same-origin API and `/mcp` proxy behavior.
2. Check login, logout, session persistence/expiry, protected-route redirects, and readable validation, 401, 404, 409, and server-error states.
3. Check projects end to end: create/edit/archive/restore/delete, asset associations, work/purchase items, costs, dates, links/vendor fields, and updates/history.
4. Check installed/spare hardware, location hierarchy, rack front/rear layouts, placement conflicts, interfaces, ports, connections, IPv4/IPv6 addresses, and relationships against the V1 demo dataset.
5. Check MCP enablement, token creation and one-time reveal, rename, expiration, enable/disable, and revocation. Confirm no raw token persists after leaving the create flow.
6. Check default device images, generic fallback for an unknown model, custom upload/removal, and cache persistence. Review narrow-screen layout, keyboard operation, focus, labels, and contrast.
7. Run `npm run typecheck` and `npm run build` from `Frontend/nuxt` when frontend checks are authorized again. Review the migrated default Compose startup. Do not tag V1 until these checks and the full goals audit pass.

The Nuxt frontend and backend containers were stopped before this record was updated. No frontend build, typecheck, or browser run was performed after the user's no-check instruction.
