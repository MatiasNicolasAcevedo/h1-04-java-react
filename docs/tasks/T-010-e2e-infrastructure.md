# T-010 · Set up Playwright E2E smoke tests and scripts/e2e.sh
- Estado: Bloqueada (espera T-002, T-003, T-007) · Prioridad: P0 · Esfuerzo: M · Agente: 🧠 frontera
- Fase: P0 Estabilizar
- Rama: `test/T-010-e2e-infrastructure` · Depende de: T-002, T-003, T-007 · Spec/ADR: docs/TESTING.md §1 (E2E)
- Revisa: ligero (segunda mirada) + dueño

## Por qué
Ningún test cubre los flujos de punta a punta (auditoría §4.7). En la auditoría el login por rol se probó a mano con Playwright redirigiendo la URL de producción; con T-003 eso deja de hacer falta.

## Objetivo
`./scripts/e2e.sh` levanta DB + back + front, corre el smoke del flujo crítico 1 (login por rol y redirección) en desktop (1280×800) y mobile (375×812), y lo corre también CI.

## Alcance
- Incluye: carpeta `e2e/` en la raíz con su `package.json` (o en `client/`, decidir y justificar), `playwright.config.js` con 2 proyectos (desktop/mobile), `webServer` o arranque vía `scripts/e2e.sh`; test `login.spec.js` (3 roles → URL esperada) y control de responsive (`document.documentElement.scrollWidth <= viewport`); job `e2e` en `ci.yml` con reporte HTML como artefacto si falla.
- **No incluye:** más flujos (tareas 🤖 posteriores copian este estilo), axe/accesibilidad (P3).

## Leer antes
- `scripts/dev.sh` (cómo arrancar y esperar cada parte) · `.github/workflows/ci.yml` (T-007)
- README paso 6 (contraseña seed) · auditoría §4.5 (medición de overflow)

## Archivos previstos
- crear: `scripts/e2e.sh`, `e2e/package.json`, `e2e/package-lock.json`, `e2e/playwright.config.js`, `e2e/tests/login.spec.js`
- modificar: `.github/workflows/ci.yml`, `docs/TESTING.md`, `AGENTS.md` (comando e2e), `README.md` (§ Tests), `.gitignore` (reportes)

## Tests
- `login.spec.js`: admin → `/admin`, doctor → `/doctorPatient`, paciente → `/patient`; credenciales inválidas → sigue en `/login` con mensaje; sin overflow horizontal en 375 px.

## Criterios de aceptación
- [ ] `./scripts/e2e.sh` termina con código 0 en local (y ≠ 0 si se rompe la redirección, probado).
- [ ] Corre en ambos viewports; screenshots y trazas solo en fallos.
- [ ] Job `e2e` en CI en verde en este PR.
- [ ] TESTING.md y AGENTS.md con el comando real.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
