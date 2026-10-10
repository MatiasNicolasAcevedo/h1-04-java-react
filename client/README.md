# Justina.io · client

SPA en React 18 + Vite 5 + Tailwind 3. Vistas por rol:

- **Doctor:** ver pacientes y turnos del día, ficha e historia clínica, seguimiento del tratamiento, recetas, consulta con dictado por voz.
- **Paciente:** turnos (pedir, ver, calendario), plan de tratamiento (medicación, nutrición, actividad física, estudios), descarga de historia clínica, configuración de perfil.
- **Admin:** agenda, alta/edición de doctores y pacientes, trasplante cruzado.

Proyecto completo, stack y paso a paso del entorno entero: [README raíz](../README.md).

## Correr solo el front

Requisitos: Node 22 (`nvm install` en la raíz del repo usa `.nvmrc`). Comandos desde `client/`.

**1. Instalar dependencias.**

```bash
npm ci
```

Resultado esperado: `added N packages` sin errores.

**2. Levantar el servidor de desarrollo.**

```bash
npm run dev
```

Resultado esperado: `Local: http://localhost:5173/`. Al abrirla se ve la landing de Justina.io.

> ⚠️ Hoy el front llama a la API de producción (`https://h1-04-java-react-qrtk.onrender.com`), fija en `src/services/*.js`. Para usar el back local ver [T-003](../docs/tasks/T-003-client-api-base-url-from-env.md); el back local se levanta con los pasos 3–5 del [README raíz](../README.md#paso-a-paso).

**3. Verificar.**

```bash
../scripts/verify.sh client
```

Resultado esperado: `client: ✅ deps ✅ lint ... ✅ build` y `RESULT: ✅ PASS`. ⚠️ Hoy falla el lint ([T-004](../docs/tasks/T-004-client-fix-lint-errors.md), [T-005](../docs/tasks/T-005-client-prop-types.md)).

## Scripts

| Script | Qué hace |
|---|---|
| `npm run dev` (o `npm start`) | Servidor de desarrollo de Vite en el puerto 5173 |
| `npm run build` | Build de producción en `dist/` |
| `npm run preview` | Sirve `dist/` para probar el build |
| `npm run lint` | ESLint (falla con cualquier warning) |

Los tests (`npm test`, Vitest) llegan con [T-006](../docs/tasks/T-006-client-test-infrastructure.md).

## Estructura

```
src/
  main.jsx, App.jsx         entrada
  Router/                   Routers.jsx (rutas) y PrivateRoute.jsx (protección por rol)
  context/DoctorContext.jsx sesión (token, rol, id) y datos compartidos
  services/                 llamadas HTTP a la API
  Components/<Área>/        pantallas: Admin, Doctor, Patient, Landing, Login, ...
  helpers/atoms/            componentes reutilizables (botones, inputs, cards)
  hooks/                    useSpeechRecognition
  Assets/                   imágenes y PDFs
```

Deploy: Firebase Hosting (`firebase.json`). Contexto para agentes: [AGENTS.md](AGENTS.md).
