# T-003 · Read the API base URL from VITE_API_URL
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🤖 agente gratuito
- Fase: P0 Estabilizar
- Rama: `fix/T-003-client-api-base-url-from-env` (crearla desde `main` actualizado antes del primer commit) · Depende de: — · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (toca configuración y deploy del front)

## Por qué
La URL de la API está fija a producción en 5 lugares (`client/src/services/authService.js:1`, `doctorServices.js:1`, `patientServices.js:1`, `appointmentService.js:1`, `client/src/Components/Admin/AddPatientForm.jsx:60`). En local el front nunca habla con el back local (auditoría §4.4, 🔴).

## Objetivo
En desarrollo el front usa `http://localhost:8080` (desde `client/.env`); el build de producción sigue usando la URL de Render.

## Alcance
- Incluye: un único módulo con la URL base; `client/.env.example` (local) y `client/.env.production` (URL de Render, no es secreta); excepción en `.gitignore` para `client/.env.production`; docs.
- **No incluye:** cambiar endpoints, refactorizar servicios, manejo de errores, `firebase.json`, CORS del back.

## Leer antes
- `client/src/services/doctorServices.js` (L1-16, estilo de servicio)
- `client/src/Components/Admin/AddPatientForm.jsx` (L55-70)
- `.gitignore` (bloque "Local environment files", final del archivo)
- `README.md` § Paso a paso, paso 7

## Archivos previstos
- crear: `client/src/services/api.js`, `client/.env.example`, `client/.env.production`
- modificar: los 4 `client/src/services/*.js`, `AddPatientForm.jsx`, `.gitignore`, `README.md` (Inicio rápido y paso 7: quitar avisos ⚠️ T-003; agregar paso `cp client/.env.example client/.env`), `client/README.md`, `docs/SETUP.md` (§ Front), `AGENTS.md` (§10), `client/AGENTS.md`

## Tests
- No hay infraestructura de tests de front todavía (T-006): verificación por comandos. No agregar librerías de test.

## Pasos sugeridos
1. `client/src/services/api.js`: `export const API = \`${import.meta.env.VITE_API_URL ?? 'http://localhost:8080'}/v1/api/\`;`
2. En cada servicio, borrar la constante local e importar `API` desde `./api`. En `AddPatientForm.jsx` usar `` `${API}patients/create` ``.
3. `client/.env.example`: `VITE_API_URL=http://localhost:8080` (con comentario). `client/.env.production`: `VITE_API_URL=https://h1-04-java-react-qrtk.onrender.com`.
4. `.gitignore`: agregar `!client/.env.production` debajo de `!.env.example`.
5. `scripts/dev.sh` ya copia `client/.env.example` si existe: comprobarlo.
6. Actualizar los docs listados.

## Criterios de aceptación
- [ ] `grep -rn "onrender.com" client/src` no devuelve resultados.
- [ ] `cd client && npm run build && grep -rl "h1-04-java-react-qrtk.onrender.com" dist/assets` encuentra el bundle (producción usa Render).
- [ ] Con `client/.env` = `.env.example`, `npm run build -- --mode development` genera un bundle que contiene `localhost:8080` (`grep -rl "localhost:8080" dist/assets`).
- [ ] Con `./scripts/dev.sh` corriendo, iniciar sesión en http://localhost:5173/login como `doctor1@doctor.com` redirige a `/doctorPatient` (README paso 6 tiene cómo obtener la contraseña).
- [ ] `git status` no muestra `client/.env`; sí se commitean `client/.env.example` y `client/.env.production`.
- [ ] `./scripts/verify.sh` sin regresiones (lint no suma errores).

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: — · Pendientes → nuevas tareas: …
