# T-016 · Redirect unauthenticated users in PrivateRoute instead of loading forever
- Estado: Bloqueada (espera T-006) · Prioridad: P0 · Esfuerzo: S · Agente: 🤖 ligero
- Fase: P0 Estabilizar
- Rama: `fix/T-016-private-route-redirect` · Depende de: T-006 · Spec/ADR: —
- Revisa: ligero en sesión nueva

## Por qué
`client/src/Router/PrivateRoute.jsx:8-20`: `loading` empieza en `true` y solo pasa a `false` cuando `authData !== null`. Sin sesión, la ruta privada muestra "Loading..." para siempre en vez de redirigir a `/` (auditoría §4.4). Además `DoctorContext` restaura `authData` de `localStorage` en un `useEffect` (`client/src/context/DoctorContext.jsx:26-33`), así que en el primer render siempre es `null`.

## Objetivo
Sin sesión → redirección a `/`; con sesión de otro rol → `/`; con el rol correcto → se ve la página, también al recargar.

## Alcance
- Incluye: inicializar `authData` en `DoctorContext` de forma síncrona (`useState(() => JSON.parse(localStorage.getItem('authData')) ?? null)` con try/catch) y quitar el estado `loading` de `PrivateRoute`.
- **No incluye:** cambiar `Routers.jsx`, separar el contexto, expiración del token.

## Leer antes
- `client/src/Router/PrivateRoute.jsx` (36 líneas) · `client/src/context/DoctorContext.jsx` (L1-35)
- Test de referencia de T-006 (`client/src/Components/Login/Login.test.jsx`) y su `renderWithProviders`

## Archivos previstos
- modificar: `PrivateRoute.jsx`, `DoctorContext.jsx` · crear: `client/src/Router/PrivateRoute.test.jsx`

## Tests (bugfix: escribir primero y verlos fallar)
1. Sin `authData` en `localStorage` → renderiza la ruta `/` (no "Loading...").
2. `authData` con `role: "PATIENT"` en una ruta `role="DOCTOR"` → `/`.
3. `authData` con `role: "DOCTOR"` en una ruta `role="DOCTOR"` → renderiza el hijo.

## Criterios de aceptación
- [ ] `npx vitest run src/Router/PrivateRoute.test.jsx` pasa (3 casos); el caso 1 fallaba antes del fix (evidencia en el PR).
- [ ] Manual: sin sesión, abrir http://localhost:5173/patient redirige a `/`; logueado como paciente y recargando `/patient` se queda en `/patient`.
- [ ] `./scripts/verify.sh client` sin regresiones; cobertura no baja.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
