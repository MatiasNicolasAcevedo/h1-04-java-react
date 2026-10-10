# T-NNN · <Título en imperativo>
- Estado: Lista · Prioridad: P0–P3 · Esfuerzo: S/M/L · Agente: 🤖 ligero | 🧠 frontera
- Fase: <P0 Estabilizar | P1 Actualizar | P2 Terminar | P3 Pulir>
- Rama: `<tipo>/T-NNN-slug` · Depende de: T-NNN · Spec/ADR: <links o "—">
- Revisa: <ligero | frontera | dueño>

## Por qué
<2–4 líneas: problema y evidencia (archivo:línea o hallazgo de la auditoría)>

## Objetivo
<resultado observable en 1–2 líneas>

## Alcance
- Incluye: ...
- **No incluye:** ... (lo que NO se debe tocar aunque parezca relacionado)

## Leer antes (máx. 5 referencias, con sección o rango de líneas)
- `server/src/.../XService.java` (método `y`, ~L40–90)
- docs/TESTING.md § Back · ejemplo a copiar: `.../XControllerTest.java`

## Archivos previstos
- modificar: ... · crear: ...

## Tests
- Agregar: <qué tests, de qué tipo, qué casos (incluido el de error)>
- Si es bugfix: test que reproduce el bug y falla antes del fix.

## Pasos sugeridos
1. ...

## Criterios de aceptación (verificables, de a uno)
- [ ] `./scripts/verify.sh` pasa y la cobertura no baja
- [ ] <comando o prueba concreta con resultado esperado>
- [ ] <comportamiento observable, p. ej. "GET /api/x sin token devuelve 401", cubierto por `XControllerTest#...`>
- [ ] Si cambió cómo se levanta o configura el proyecto: README/SETUP actualizados y probados

## Notas de implementación  _(las completa quien implementa; también antes de compactar)_
- Hecho: ... · Pendiente: ... · Próximo paso: ...

## Resultado  _(al cerrar)_
- PR: #N · Qué cambió: ... · Tests agregados: ... · Pendientes → nuevas tareas: T-NNN
