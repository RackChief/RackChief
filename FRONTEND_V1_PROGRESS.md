# Frontend V1 work state — 2026-09-29

The active scope is `Frontend/RackChief-Frontend-V1-Goals.md` (Nuxt edition). V1 is **incomplete**. Work was stopped at the user's request after the image-service milestone was interrupted. Do not retire the React app or switch the primary Compose stack yet.

## Implemented

- Existing React app was expanded with component inventory, locations, racks and placement, network details, asset relationships, project links, MCP settings, and same-origin API/MCP proxies. It remains the primary app in `docker-compose.dev.yml`.
- A Nuxt 4 staging app lives in `Frontend/nuxt`, run with `docker-compose.nuxt.dev.yml` on port 5175. It has Supabase login/session handling, protected routes, centralized API access, assets and asset detail, components and spares, locations, racks and placement, network inventory, relationships, projects, MCP settings, About/Attributions, and RackChief branding.
- Backend device-image routes and OpenAPI entries were added in `Backend/src/modules/device-images`. Images are fetched lazily from the NetBox Community Device Type Library, cached by manufacturer/model, and overridden by per-asset PNG/JPEG/WebP uploads. Both Compose files bind `./.data/device-images` to `/data/device-images`, so the cache survives container recreation and `docker compose down -v`.
- Asset and rack views now render a `DeviceFaceplate` through Nuxt Image, with a generic labeled faceplate fallback. Asset detail includes custom front/rear upload and removal controls.

## Verification completed

- Backend `npm run build` passed after the device-image changes.
- Nuxt `npm run typecheck` and `npm run build` passed after the signed URL code was added.
- The staging stack returned HTTP 200 for page routes and the unauthenticated asset API returned 401.
- A known Dell PowerEdge R730xd front image fetched from the NetBox Library and resolved from the local cache on a second lookup. A real development asset with model `R730XD` resolved the same default image.
- Custom image upload returned 200; image read returned PNG bytes; a backend restart preserved the override; deletion returned 204 and cleared override metadata. Invalid upload returned 400 and unauthenticated upload returned 401. The generated OpenAPI document contained the image paths.

## Immediate unresolved issue

The final signed image URL change is **not working end to end**. The authenticated `/api/v1/device-images/:assetId/urls` route returned 200, and direct GET using its signed URL returned 200. The equivalent Nuxt Image IPX URL returned 400 because its query parameters were not forwarded to the backend image route. An unsigned direct image request also returned 400 from query validation. This means current rack and asset image rendering may show only the generic fallback. The next implementation step is to put expiry/signature in URL path segments (and use a nonce for cache busting), then update the backend route, OpenAPI, frontend URL handling, and repeat the IPX check. No fix was made after the user requested an immediate stop.

## Remaining V1 work

- Resolve the signed image URL/IPX issue, test missing-image fallback and cache persistence through a full stack restart, and assess image lookup coverage and remote-error caching.
- Complete a requirement-by-requirement audit of the Nuxt goals, including UI behavior, auth/session expiry, API error states, all CRUD flows, responsive/accessibility checks, and the V1 demo dataset. Current HTTP checks do not prove browser UI behavior.
- Review the image route security and operational behavior, including public exposure of signed URLs, upload validation, cache lifecycle, and upstream timeouts.
- Once Nuxt reaches and verifies full parity, switch the primary Compose stack and docs to Nuxt and retire the React app as directed by the goals file.

## Resume commands

From the repository root, run `docker compose -f docker-compose.nuxt.dev.yml up --build` to start staging, and `docker compose -f docker-compose.nuxt.dev.yml down` to stop it. From `Frontend/nuxt`, run `npm run typecheck` and `npm run build`; from `Backend`, run `npm run build`. Staging services were stopped before this state was recorded. The development database was not reset. The temporary custom image override created during verification was removed; the downloaded default image remains in the ignored `.data/device-images` cache.
