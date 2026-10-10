# Tablero
> Reglas: **una tarea a la vez** (máx. 1 PR abierto) · se toma siempre **la primera** de "Listas" ·
> si es 🧠 y sos el agente gratuito, no la tomes: avisá al dueño que la siguiente va con modelo de frontera ·
> una tarea con PR abierto o rama remota `*/T-NNN-*` está tomada ·
> formato: `- T-NNN · Pn · S/M/L · 🤖 ligero|🧠 frontera|👤 dueño · Título → [tarea](tasks/T-NNN-slug.md)`
> Próximo ID libre: T-021

## 🔨 En curso / en revisión (con su PR)
- T-019 · P0 · M · 🧠 frontera · Alinear flujo de agentes y docs con el prompt de bootstrap v3 → [tarea](tasks/T-019-align-agent-workflow-with-bootstrap-v3.md) · PR en draft

## ✅ Listas (en orden de ejecución, máx. 10)
- T-003 · P0 · S · 🤖 ligero · URL de la API desde `VITE_API_URL` → [tarea](tasks/T-003-client-api-base-url-from-env.md)
- T-002 · P0 · S · 🤖 ligero · El back carga `server/.env` solo → [tarea](tasks/T-002-server-load-dotenv.md)
- T-020 · P0 · M · 🧠 frontera · Contenerizar la app completa y completar el harness (depende de T-002 y T-003, que van antes) → [tarea](tasks/T-020-containerize-full-app-and-complete-harness.md)
- T-014 · P0 · S · 🤖 ligero · Quitar `console.log` con credenciales y datos personales → [tarea](tasks/T-014-client-remove-credential-logs.md)
- T-001 · P0 · M · 🧠 frontera · Infraestructura de tests del back (Testcontainers + JaCoCo) → [tarea](tasks/T-001-server-test-infrastructure.md)
- T-004 · P0 · M · 🤖 ligero · Errores de ESLint (salvo prop-types y hooks) → [tarea](tasks/T-004-client-fix-lint-errors.md)
- T-005 · P0 · M · 🤖 ligero · PropTypes en los 14 componentes que fallan → [tarea](tasks/T-005-client-prop-types.md)
- T-018 · P0 · S · 🧠 frontera · Warnings `exhaustive-deps` sin cambiar comportamiento → [tarea](tasks/T-018-client-hooks-exhaustive-deps.md)
- T-006 · P0 · M · 🧠 frontera · Infraestructura de tests del front (Vitest + RTL + MSW) → [tarea](tasks/T-006-client-test-infrastructure.md)
- T-011 · P0 · S · 👤 dueño · Protección de `main` en GitHub (no bloquea la cola; hacerla cuando puedas) → [tarea](tasks/T-011-owner-branch-protection.md)

## ⛔ Bloqueadas (entran a "Listas" en este orden cuando se cumple su dependencia)
- T-008 · P0 · M · 🧠 frontera · Registro de admin solo para admins + contraseñas seed por env (🔴) → [tarea](tasks/T-008-server-secure-admin-register-and-seed-credentials.md) · bloqueada por: T-001
- T-015 · P0 · S · 🤖 ligero · Tests de caracterización de login y endpoints protegidos → [tarea](tasks/T-015-server-auth-characterization-tests.md) · bloqueada por: T-001
- T-013 · P0 · S · 🤖 ligero · Ping keep-alive de Render solo si está habilitado → [tarea](tasks/T-013-server-keepalive-only-in-prod.md) · bloqueada por: T-001
- T-017 · P0 · M · 🤖 ligero · 400/404 correctos y sin filtrar detalles en errores → [tarea](tasks/T-017-server-error-responses.md) · bloqueada por: T-015
- T-016 · P0 · S · 🤖 ligero · `PrivateRoute` redirige sin sesión → [tarea](tasks/T-016-client-private-route-redirect.md) · bloqueada por: T-006
- T-007 · P0 · S · 🧠 frontera · CI con `verify.sh` → [tarea](tasks/T-007-ci-workflow.md) · bloqueada por: T-001, T-004, T-005, T-018
- T-012 · P0 · S · 🤖 ligero · Dependabot → [tarea](tasks/T-012-dependabot.md) · bloqueada por: T-007
- T-010 · P0 · M · 🧠 frontera · E2E Playwright + `scripts/e2e.sh` → [tarea](tasks/T-010-e2e-infrastructure.md) · bloqueada por: T-002, T-003, T-007
- T-009 · P0 · L · 🧠 frontera · Autorización por rol en todos los endpoints (🔴) → [tarea](tasks/T-009-server-role-based-authorization.md) · bloqueada por: decisión del dueño (matriz), T-008, T-015

## 📥 Backlog (sin refinar: una línea, sin archivo de tarea todavía)
- Caracterización por controller (doctors, patients, appointments, treatments) siguiendo `AuthFlowIT` · P0 · 🤖
- `npm audit fix` dentro de rangos semver + build/lint · P1 · 🤖
- Spring Boot 3.3 → 3.5 (+ springdoc 2.8, jjwt 0.12) · P1 · 🧠 · [ADR 0003](adr/0003-upgrade-path-spring-boot.md)
- Spring Boot 3.5 → 4.x con OpenRewrite · P1 · 🧠
- Java 21 como target (`java.version`), imagen `eclipse-temurin` en `Dockerfile` · P1 · 🧠
- Vite 5 → 7/8, React 18 → 19, React Router 7, ESLint 9 flat config · P1 · 🧠
- Tailwind 3 → 4 · P1 · 🧠
- Reemplazar o quitar `react-simple-chatbot` (abandonada) · P1 · 🧠 · decisión del dueño
- Flyway + perfiles `dev`/`demo`/`prod`, `ddl-auto=validate` · P1 · 🧠 · [ADR 0001](adr/0001-postgresql-as-only-database.md)
- Quitar driver MySQL, `javax.mail-api` y `swagger-models` fijado · P1 · 🤖
- Logging DEBUG solo en perfil `dev`; logger en lugar de `System.out` · P1 · 🤖
- Formateadores: Prettier (front) y Spotless (back) en un PR de solo formato · P1 · 🧠
- OWASP dependency-check en CI · P1 · 🧠
- Errores con `ProblemDetail` y sin try/catch en controllers · P1 · 🧠
- Spec y seed de turnos (agenda del doctor y del admin desde la API) · P2 · 🧠
- Conectar planes de tratamiento del paciente a la API (hoy mock) · P2 · 🧠
- Spec de trasplante cruzado (`CrossTransplant` sin endpoints) · P2 · 🧠
- Recuperar contraseña (endpoint + email) · P2 · 🧠
- Mailpit en docker-compose para probar emails en local · P2 · 🤖
- Paginación en listados (`getAll*`) y revisión de N+1 · P2 · 🧠
- Separar `AuthContext` de `DoctorContext`; cliente HTTP único · P2 · 🧠
- Inyección por constructor al tocar cada clase; `Clock` inyectado · P2 · 🤖
- Rate limiting del login · P2 · 🧠
- JWT en `localStorage`: evaluar cookie httpOnly (ADR) · P2 · 🧠
- Partir `NewTurn.jsx` (994 líneas) y `Routers.jsx` · P2 · 🧠
- Overflow horizontal de la landing en 768 px · P3 · 🤖
- Íconos offline (sin `api.iconify.design` en runtime) · P3 · 🤖
- Lazy routes para bajar el bundle de 678 kB · P3 · 🤖
- Accesibilidad con axe en E2E · P3 · 🤖
- Capturas propias en `docs/images/`, badges de cobertura · P3 · 🤖
- Regla `no-console` en ESLint · P3 · 🤖
- Migrar el front a TypeScript (y quitar `eslint-disable react/prop-types`) · P3 · 🧠
- Nombres consistentes (`Pacient/`, `Weekk.jsx`, `DataLoaderAppoinment`) · P3 · 🤖
- Licencia del proyecto · P3 · 👤 dueño
- Deploy desde CI (Render + Firebase) · P3 · 🧠

## 🏁 Hecho reciente (máx. 10; las más viejas → archive/tasks/)
- T-000 · Auditoría inicial y harness para agentes · 2026-10-10 · [PR #1](https://github.com/MatiasNicolasAcevedo/h1-04-java-react/pull/1)
