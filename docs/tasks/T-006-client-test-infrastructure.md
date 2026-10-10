# T-006 · Set up client test infrastructure (Vitest + Testing Library + MSW)
- Estado: Lista · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `test/T-006-client-test-infrastructure` (crearla desde `main` actualizado antes del primer commit) · Depende de: — · Spec/ADR: docs/TESTING.md §1
- Revisa: 🧠 modelo de frontera (sesión nueva, o sub-agente si el dueño lo pide) + 👤 dueño

## Por qué
El front no tiene tests ni script `test` (auditoría §4.7). Las tareas 🤖 de front (T-016 y la caracterización) necesitan un test de referencia para copiar el estilo.

## Objetivo
`npm test` corre Vitest con jsdom, Testing Library y MSW; hay un test de ejemplo de un componente con llamada a la API y la cobertura queda medida con umbral de base.

## Alcance
- Incluye: devDependencies `vitest`, `@vitest/coverage-v8`, `jsdom`, `@testing-library/react`, `@testing-library/jest-dom`, `@testing-library/user-event`, `msw` (versiones compatibles con Vite 5 y React 18); `test` en `vite.config.js` (o `vitest.config.js`); `src/test/setup.js` (jest-dom + server MSW); `src/test/msw/handlers.js` con login y `doctors/getAllDoctors`; scripts `test` (`vitest run`) y `test:coverage`; ESLint para archivos de test (globals de Vitest).
- **No incluye:** migrar a Vite 7/React 19 (P1), cambiar componentes salvo un ajuste mínimo para testabilidad justificado.

## Leer antes
- `client/package.json`, `client/vite.config.js`, `client/.eslintrc.cjs`
- `client/src/Components/Login/Login.jsx` (L1-75 y el `<form>` ~L128-180)
- `client/src/context/DoctorContext.jsx` (L1-35)
- docs/TESTING.md §1, §3, §5

## Archivos previstos
- modificar: `client/package.json`, `client/package-lock.json`, `client/vite.config.js`, `client/.eslintrc.cjs`
- crear: `client/src/test/setup.js`, `client/src/test/msw/{handlers,server}.js`, `client/src/test/renderWithProviders.jsx`, `client/src/Components/Login/Login.test.jsx`
- docs: `docs/TESTING.md` (referencia real), `AGENTS.md`/`client/AGENTS.md` (comando de un test), `client/README.md` (scripts), `docs/STATUS.md`

## Tests
- `Login.test.jsx`: (a) login correcto de un DOCTOR → navega a `/doctorPatient`; (b) credenciales inválidas (MSW 401) → muestra el mensaje de error y no navega. Consultas por label/rol.

## Pasos sugeridos
1. Instalar devDependencies; configurar `test: { environment: 'jsdom', setupFiles, coverage: { provider: 'v8', thresholds } }`.
2. MSW: los handlers interceptan **cualquier** origen (`*/v1/api/auth/login`), así funcionan con la URL fija actual y con la de T-003.
3. Helper `renderWithProviders` con `MemoryRouter` + `DoctorProvider`.
4. Medir cobertura y fijar `thresholds` en la línea de base (redondeo hacia abajo).
5. `scripts/verify.sh` ya corre `npm test` si existe el script: comprobarlo.

## Criterios de aceptación
- [ ] `cd client && npm test` pasa con ≥ 2 tests.
- [ ] `npx vitest run src/Components/Login/Login.test.jsx -t "redirects"` corre un solo test.
- [ ] `npm run test:coverage` genera `coverage/` y falla si se baja el umbral (probado).
- [ ] `./scripts/verify.sh client` muestra `✅ tests` (el lint puede seguir fallando si T-004/T-005 no se mergearon).
- [ ] TESTING.md cita `Login.test.jsx` como referencia; STATUS.md con cobertura de base.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
