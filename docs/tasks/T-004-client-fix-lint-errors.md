# T-004 · Fix ESLint errors other than react/prop-types
- Estado: Lista · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🤖 agente gratuito
- Fase: P0 Estabilizar
- Rama: `fix/T-004-client-fix-lint-errors` (crearla desde `main` actualizado antes del primer commit) · Depende de: — · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (esfuerzo M)

## Por qué
`npm run lint` falla con 87 problemas (auditoría §3). Esta tarea cubre los **53 que no son `react/prop-types`** ni `react-hooks/exhaustive-deps`: `no-unused-vars` (41), `no-irregular-whitespace` (5), `react/no-unknown-property` (2), `react/jsx-key` (1), `no-undef` (1) y 3 directivas `eslint-disable` sin uso (`src/Components/ChatBot/MainChatBot.jsx:1`, `src/Components/Patient/Treatment/Plans/PlanGim.jsx:1`, `src/Components/Patient/Treatment/Plans/PlanNutrition/PlanNutrition.jsx:1`). Son cambios de 1 línea en ~28 archivos: se acepta superar el tope orientativo de archivos.

## Objetivo
`npx eslint . --ext js,jsx --rule 'react/prop-types: off' --rule 'react-hooks/exhaustive-deps: off'` (desde `client/`) termina sin errores (hoy: 50), y las 3 directivas sin uso listadas arriba están borradas.

> ⚠️ No agregues `--report-unused-disable-directives` a ese comando: con `prop-types` apagado, las ~24 directivas `/* eslint-disable react/prop-types */` aparecerían como "sin uso" y **no hay que borrarlas** (se quedan; ver T-005).

## Alcance
- Incluye: borrar imports/variables sin uso; reemplazar espacios irregulares por espacios normales; borrar **solo** las 3 directivas `eslint-disable` listadas en "Por qué"; `srcset` → `srcSet`; agregar `key` en el `.map` de `FooterLanding.jsx:192`; `webkitSpeechRecognition` → `window.webkitSpeechRecognition` en `src/hooks/useSpeechRecognition.jsx:6`.
- **No incluye:** `react/prop-types` (T-005), `react-hooks/exhaustive-deps` (T-018), cambiar `.eslintrc.cjs`, desactivar reglas, reformatear archivos, cambiar lógica.

## Leer antes
- Solo la salida del comando del Objetivo (archivo:línea:regla) y **las líneas señaladas** de cada archivo (±5 líneas). No abras archivos completos; `NewTurn.jsx` tiene 994 líneas.

## Archivos previstos
- modificar: los archivos que liste el comando (≈28 en `client/src/`)

## Tests
- No hay tests de front (T-006). La verificación es el lint + build. Si borrás una variable "sin uso", confirmá con grep en el archivo que no se usa más abajo.

## Pasos sugeridos
1. `cd client && npx eslint . --ext js,jsx --rule 'react/prop-types: off' --rule 'react-hooks/exhaustive-deps: off' > /tmp/lint.txt; tail -n 3 /tmp/lint.txt`.
2. Ir archivo por archivo; commitear por grupo de regla (p. ej. `fix(client): remove unused imports and variables`).
3. Si borrar un import de `React` deja el archivo sin errores, está bien (el proyecto usa el JSX runtime nuevo).
4. Correr el comando del paso 1 y `npm run build` al final.

## Criterios de aceptación
- [ ] El comando del Objetivo sale con código 0.
- [ ] `npm run lint` solo reporta `react/prop-types` y `react-hooks/exhaustive-deps` (`npm run lint 2>&1 | grep -E "error|warning" | grep -vE "react/prop-types|exhaustive-deps" | grep -v problems` vacío).
- [ ] `npm run build` pasa.
- [ ] `git diff --stat` solo toca archivos de `client/src/` y el tablero/STATUS/tarea.
- [ ] `./scripts/verify.sh client` sin regresiones (el lint baja de 87 problemas).

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: — · Pendientes → nuevas tareas: …
