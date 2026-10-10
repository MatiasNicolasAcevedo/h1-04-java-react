# T-014 · Remove console.log calls that print credentials or personal data
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🤖 agente gratuito
- Fase: P0 Estabilizar
- Rama: `fix/T-014-remove-credential-logs` (crearla desde `main` actualizado antes del primer commit) · Depende de: — · Spec/ADR: —
- Revisa: 🤖 agente gratuito (chat nuevo) · S, solo borra líneas

## Por qué
🟠 El login imprime email y contraseña en la consola del navegador (`client/src/Components/Login/Login.jsx:49-50`); otros `console.log` imprimen el token o datos de pacientes (auditoría §4.6).

## Objetivo
Ningún `console.log` del front imprime credenciales, tokens ni datos personales.

## Alcance
- Incluye: **borrar** estas líneas: `src/App.jsx:8` (`authData`, incluye el token) · `src/Components/Login/Login.jsx:49-50` · `src/Components/Admin/AddPatientForm.jsx:43` (token) y `:58` (datos del paciente) · `src/Components/Admin/Settings.jsx:37` · `src/Components/Doctor/DoctorConfiguration/DoctorConfiguration.jsx:37` · `src/Components/Patient/Turn/NewTurn/NewTurn.jsx:162` · `src/Components/Patient/Turn/TurnCalendar/TurnCalendar.jsx:43` · `src/Components/Doctor/PatientRecord/TreatmentFollowUp/CardTreatmentFollowUp.jsx:9`. Si al borrar una línea queda una variable o import sin uso, borrarlo también (solo si `npm run lint` lo marca como nuevo).
- **No incluye:** los `console.log(error)` (se quedan), la línea comentada `NewTurn.jsx:662`, `AddPatientForm.jsx:66` (solo status), agregar la regla `no-console` (backlog), cambiar lógica.

## Leer antes
- Solo cada línea listada ±5 líneas (no abras `NewTurn.jsx` entero: 994 líneas).

## Archivos previstos
- modificar: los 8 archivos listados.

## Tests
- No hay tests de front (T-006). Verificación por grep + lint + build.

## Criterios de aceptación
- [ ] `grep -rnE "console\.log\(.*(Email|password|Password|token|Token|authData|patientData|adminData|appointmentData|appointments|showVerificando)" client/src --include=*.jsx --include=*.js | grep -vE ":[0-9]+:\s*//"` sin resultados (hoy devuelve 10 líneas).
- [ ] `npm run lint` no tiene más problemas que en `main` (comparar el total).
- [ ] `npm run build` pasa.
- [ ] `./scripts/verify.sh client` sin regresiones.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: — · Pendientes → nuevas tareas: …
