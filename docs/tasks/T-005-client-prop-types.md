# T-005 · Declare PropTypes in the 14 components that fail react/prop-types
- Estado: Lista · Prioridad: P0 · Esfuerzo: M · Agente: 🤖 ligero
- Fase: P0 Estabilizar
- Rama: `fix/T-005-client-prop-types` · Depende de: — (si T-004 ya se mergeó, partir de `main` actualizado) · Spec/ADR: —
- Revisa: ligero en sesión nueva

## Por qué
`npm run lint` reporta 31 errores `react/prop-types` en 14 componentes (auditoría §3, §4.10). El proyecto ya usa `prop-types` (dependencia en `client/package.json`) y tiene un ejemplo: `client/src/helpers/atoms/FormComponent.jsx`.

## Objetivo
`npm run lint 2>&1 | grep -c "react/prop-types"` → `0`, declarando `propTypes` (no desactivando la regla).

## Alcance
- Incluye: agregar `import PropTypes from 'prop-types'` y `Componente.propTypes = { ... }` en estos archivos (entre paréntesis, cantidad de errores):
  `src/helpers/atoms/DoctorCard.jsx` (6) · `src/helpers/atoms/CardPatient.jsx` (5) · `src/Components/Doctor/PatientRecords/Record.jsx` (4) · `src/Components/Doctor/PatientRecord/MedicalHistory/CardMedicalHistory.jsx` (4) · `src/Components/Patient/Turn/NewTurn/CalendarTurn.jsx` (3) · `src/Components/Admin/EditPatientForm.jsx` (2) · `src/Components/Admin/EditDoctorForm.jsx` (2) · `src/helpers/atoms/ProfileButton.jsx` · `src/Components/Patient/Treatment/Plans/PlanNutrition/PlanNutrition.jsx` · `src/Components/Patient/Treatment/Plans/PlanGim.jsx` · `src/Components/Layout/HomeLayout.jsx` · `src/Components/Doctor/PatientRecords/MainRecords.jsx` · `src/Components/Admin/AddPatientForm.jsx` · `src/Components/Admin/AddDoctorForm.jsx` (1 cada uno).
- **No incluye:** las ~24 directivas `/* eslint-disable react/prop-types */` que ya existen en otros archivos (se quedan; su limpieza va con la migración a TypeScript, backlog P3); `.eslintrc.cjs`; cambios de lógica o de JSX.

## Leer antes
- `client/src/helpers/atoms/FormComponent.jsx` (L1-3 y L28-35: estilo a copiar)
- Por archivo: solo la firma del componente y las líneas que marca `npm run lint` (±5).

## Archivos previstos
- modificar: los 14 archivos listados (≈ 3-10 líneas por archivo)

## Tests
- No hay tests de front (T-006). Verificación por lint + build.

## Pasos sugeridos
1. `cd client && npm run lint 2>&1 | grep -B1000 "problems" | grep -E "^/|react/prop-types"` para ver archivo y prop faltante.
2. Tipos: inferirlos del uso (`.map` → `PropTypes.array`/`arrayOf`, `onClick` → `PropTypes.func`, objetos con campos usados → `PropTypes.shape({...})`, `children` → `PropTypes.node`). Si una prop se usa siempre, `.isRequired`; si dudás, sin `.isRequired`.
3. Commits por grupo (`fix(client): add prop types to admin forms`, …).

## Criterios de aceptación
- [ ] `npm run lint 2>&1 | grep -c "react/prop-types"` imprime `0` (las directivas existentes no se tocaron).
- [ ] `git diff main --stat` muestra solo los 14 archivos + tablero/STATUS/tarea.
- [ ] `npm run build` pasa.
- [ ] `npm run dev` y abrir `/login` y `/`: sin warnings `Failed prop type` en la consola del navegador para esas pantallas (si no podés abrir un navegador, decilo en el PR).
- [ ] `./scripts/verify.sh client` sin regresiones.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: — · Pendientes → nuevas tareas: …
