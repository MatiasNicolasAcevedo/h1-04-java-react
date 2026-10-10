# T-020 · Containerize the full app and complete the harness
- Estado: Lista (en la cola después de T-003 y T-002, de las que depende) · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `build/T-020-containerize-full-app` (crearla desde `main` actualizado antes del primer commit) · Depende de: T-002, T-003 · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (sesión nueva o sub-agente si el dueño lo pide) + 👤 dueño

## Por qué
Hoy `docker-compose.yml` solo levanta la DB (`docker-compose.yml:1`) y `server/Dockerfile` es el de producción (Render). El prompt v3 (§3.1, §3.3, §3.4) pide poder levantar todo con Docker como único requisito y un `verify.sh` con flags, logs en el repo y pistas. Con T-002 (back lee `server/.env`) y T-003 (front lee `VITE_API_URL`) la app completa ya se puede configurar sin argumentos.

## Objetivo
`docker compose --profile app up -d --build` levanta DB + back + front en local con los `.example` copiados tal cual, y el harness (`verify.sh`, `dev.sh`) queda completo según v3.

## Alcance
- Incluye:
  - `docker-compose.yml`: servicios `server` y `client` bajo `profiles: [app]`, con `depends_on: db: condition: service_healthy`, variables de los `.example` y puertos 8080 / 5173. Sin profile sigue levantando solo `db`.
  - `server/Dockerfile.dev` (multi-stage, `eclipse-temurin` 21) y `client/Dockerfile` de desarrollo (`node` 22); `.dockerignore` en `server/` y `client/` (`target/`, `node_modules/`, `dist/`, `.env`).
  - README: "Opción A · todo en contenedores" (copiar `.example` → `up --profile app` → URLs → `down -v`), tabla "Configurar variables de entorno" (`ejemplo | copiar a | quién lo lee | qué contiene`) y `core.autocrlf` en § Windows.
  - `docs/SETUP.md`: columna "dónde se define en prod" (Render / Firebase) en las tablas de variables.
  - `scripts/verify.sh`: flags `--server` / `--client` (conservando `server` / `client` por compatibilidad); logs en `.verify-logs/` (agregar a `.gitignore`); JDK en el resumen (`server: ✅ build ✅ tests (N) [JDK 21]`); pista conocida si falla el build (p. ej. versión de JDK); levantar la DB con compose si hace falta y Docker está disponible.
  - `scripts/dev.sh`: `--down` (apaga la DB) y mostrar el usuario demo al terminar de levantar (email; la contraseña se remite al seed, no se copia).
  - Auditoría inicial: agregar al final los probes HTTP de v3 (Fase 1, paso 9) con status obtenido y esperado: sin token, token inválido, JSON inválido, recurso inexistente, login con email inexistente y con password incorrecta.
- **No incluye:** `server/Dockerfile` (producción), `client/firebase.json`, CI, código de la aplicación, cambiar puertos o variables.

## Leer antes
- Prompt v3 §3.1, §3.3, §3.4 (en el PR de T-019 o pedírselo al dueño) · `docker-compose.yml` · `server/Dockerfile`
- `scripts/verify.sh` (todo, ~95 líneas) · `scripts/dev.sh` (todo)
- `README.md` § Levantar el proyecto en local (~L42–206) · `docs/SETUP.md` § Variables de entorno

## Archivos previstos
- modificar: `docker-compose.yml`, `scripts/verify.sh`, `scripts/dev.sh`, `.gitignore`, `README.md`, `docs/SETUP.md`, `AGENTS.md` (§3 comandos), `docs/audits/2026-10-10-initial.md` (solo al final), `.claude/settings.json` (flags nuevos)
- crear: `server/Dockerfile.dev`, `server/.dockerignore`, `client/Dockerfile`, `client/.dockerignore`

## Tests
- Infra local, sin tests automatizados nuevos. Verificación por comando (criterios), siempre desde un `git clone` limpio.

## Criterios de aceptación
- [ ] `docker compose down -v && docker compose up -d --wait` levanta solo `db` (`Healthy`).
- [ ] `docker compose --profile app up -d --build`: `curl -fsS http://localhost:8080/v1/api/render/health` responde; `http://localhost:5173` carga; login con el usuario demo desde la pantalla llega al back local.
- [ ] `./scripts/verify.sh --server`, `--client`, `server` y `client` funcionan; los logs quedan en `.verify-logs/` (ignorado); el resumen muestra el JDK.
- [ ] `./scripts/dev.sh --down` apaga la DB; `./scripts/dev.sh` muestra el usuario demo.
- [ ] Probes HTTP registrados en la auditoría con status obtenido y esperado (los que no coinciden → T-017).
- [ ] `bash -n scripts/*.sh` y `./scripts/verify.sh` sin regresiones respecto de `main`.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: — · Pendientes → nuevas tareas: …
