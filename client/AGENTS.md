# client/AGENTS.md

Solo lo específico del front. Lo general está en [../AGENTS.md](../AGENTS.md).

- Entrada `src/main.jsx` → `src/App.jsx` → rutas en `src/Router/Routers.jsx` (470 líneas: leé por rangos) con `PrivateRoute role="DOCTOR|PATIENT|ADMIN"`.
- Pantallas en `src/Components/<Área>/`; piezas reutilizables en `src/helpers/atoms/`; hooks en `src/hooks/`; HTTP solo en `src/services/*.js`; sesión (`authData` = `{ token, role, id }` en `localStorage`) en `src/context/DoctorContext.jsx`.
- Estilos: Tailwind (`tailwind.config.js`) + CSS por componente. Imágenes en `src/Assets/` (no las abras: son binarios).
- Muchas pantallas usan **datos de ejemplo** (`src/Components/Patient/Treatment/data.js`, `Doctor/Transplant/*Data.js`, `Admin/Appointments.jsx`): no asumas que vienen del back.
- La URL de la API está fija a producción en `src/services/*.js` y `Components/Admin/AddPatientForm.jsx:60` hasta T-003.
- Comandos (desde `client/`): `npm ci` · `npm run dev` · `npm run lint` · `npm run build` · gate: `../scripts/verify.sh client`.
- Tests: todavía no hay; la infraestructura (Vitest + Testing Library + MSW) llega con T-006.
- Archivo grande: `src/Components/Patient/Turn/NewTurn/NewTurn.jsx` (994 líneas): nunca lo leas completo.
