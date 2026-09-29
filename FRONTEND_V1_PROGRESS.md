# Frontend V1 work state — 2026-09-29

The active scope is `Frontend/RackChief-Frontend-V1-Goals.md` (Nuxt edition). V1 is **incomplete**. Do not retire the React app or switch the primary Compose stack yet.

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
- After a full Compose down/up cycle, a known default image returned 200 from the `netbox` cache with the cache file's modification time unchanged. A signed image for an asset without manufacturer/model returned 404 through IPX.

## Signed image URL follow-up

The initial query-string signature failed through Nuxt Image IPX. The resumed work moved expiry, a cache-busting nonce, and the signature into URL path segments. The authenticated URL issuer returned 200; a valid image returned 200 directly and through IPX; an unsigned URL returned 404 and a tampered signature returned 401. The optimized PNG response was 57,892 bytes.

## Latest browser pass and paused work

- Authenticated Chromium checks loaded Nuxt assets, components, locations, racks, projects, MCP settings, and About without page errors. An existing Dell asset detail rendered front and rear images with nonzero natural widths. Demo rack placements used generic faceplates because their manufacturer/model fields are empty.
- The rack page overflowed a 390 px viewport. The pending Nuxt CSS change constrained rack rows and faceplates; Chromium then reported `document.scrollWidth === 390` with no overflowing elements.
- A disposable asset create attempt exposed an invalid empty IP address sent to PostgreSQL `inet`. Pending changes make asset create omit blank optional strings in both Nuxt and React and use the networking IP schema for backend create/update validation. Backend build, Nuxt typecheck/build, and React build passed after those changes.
- After rebuilding staging, asset creation succeeded, but navigation to its detail page raised `A <SelectItem /> must have a value prop that is not an empty string` and `Cannot read properties of null (reading 'type')`. The temporary asset was deleted. Nuxt `USelect` options with `value: ''` appear in `AssetForm.vue`, `ComponentForm.vue`, `AssetNetwork.vue`, locations and racks pages. Replace those empty option values with a UI sentinel and map it to `null` before API calls, then repeat the asset lifecycle and other form checks.
- Staging Compose is stopped. No disposable test records remain. The pending code changes are committed with this progress note as a pause checkpoint; the empty-select issue is still unresolved.

## Implementation after the pause

- Replaced Nuxt `USelect` options with empty values across assets, components, network ports/connections, locations, and racks. The UI uses a nonempty selection marker and sends `null` for optional API fields.
- Before the instruction to stop frontend checks, authenticated Chromium successfully created, opened, edited, archived, restored, and deleted a disposable asset. It also rendered the component, location, and rack forms without page errors. A second disposable run created, edited, and deleted a location and spare component; created and edited a rack; placed and removed an asset; and deleted the rack. Test records were cleaned up.
- Subsequent source changes have **not** been checked: missing Supabase sessions redirect to login; project item type changes clear purchase-only data; location parent choices exclude descendants; device-image lookup has a total time budget and short retry pause after upstream errors; permanent asset deletion cleans up custom image files; temporary image upload files no longer count as available overrides.
- The user requested implementation only and will inspect manually. Do not run frontend builds, typechecks, browsers, or other frontend checks until that instruction changes. The Nuxt staging Compose stack is stopped.
- Automatic approval review rejected removing the tracked React/Vite app because full Nuxt V1 parity has not been verified. Do not remove React or switch the primary Compose app as an indirect workaround. That migration remains pending manual inspection or renewed authorization after parity evidence is available.

## Remaining V1 work

- Test missing-image fallback and upload UI visually in a browser; assess image lookup coverage and remote-error caching.
- Manually inspect project, networking, relationships, MCP token, image upload/fallback, login/logout, session expiry, error states, and responsive/accessibility behavior. Asset, location, spare component, rack, and placement browser flows passed before the check restriction; later source edits remain unverified.
- Complete a requirement-by-requirement audit of the Nuxt goals and V1 demo dataset with evidence from the user's manual inspection when available.
- Review the image route security and operational behavior, including public exposure of signed URLs, upload validation, cache lifecycle, and upstream timeouts.
- Once Nuxt reaches and verifies full parity, switch the primary Compose stack and docs to Nuxt and retire the React app as directed by the goals file. The attempted tracked React deletion was rejected by automatic approval review pending this evidence.

## Resume commands

From the repository root, run `docker compose -f docker-compose.nuxt.dev.yml up --build` to start staging, and `docker compose -f docker-compose.nuxt.dev.yml down` to stop it. From `Frontend/nuxt`, run `npm run typecheck` and `npm run build`; from `Backend`, run `npm run build`. Staging services were stopped before this state was recorded. The development database was not reset. Temporary browser-test assets and the custom image override were removed; the downloaded default image remains in the ignored `.data/device-images` cache. Root `assets/` is user-provided untracked brand material and was left untouched.
