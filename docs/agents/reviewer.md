# Protocolo: revisar un PR

Sos el agente revisor, en una **sesión nueva** (sin el contexto de quien implementó). **Un PR por sesión.** El usuario te dice el número: `#N`.

## 1. Leer
- `AGENTS.md`, `CONTRIBUTING.md`, `docs/TESTING.md`.
- El PR: `gh pr view N` (descripción y comentarios) y el diff completo: `gh pr diff N`.
- El archivo de la tarea que enlaza el PR (`docs/tasks/T-NNN-*.md`).
- Del código circundante, solo lo necesario para entender el diff (por rangos).

## 2. Verificar vos mismo
- `gh pr checkout N` y `./scripts/verify.sh`. No confíes solo en lo que dice el PR.
- Estado de CI: `gh pr checks N`.
- Compará con `main` si hace falta: `git diff main --stat`.

## 3. Revisar, en este orden
1. **Criterios de aceptación:** uno por uno, ¿se cumplen de verdad? ¿Hay un test o comando que lo demuestre? Corré los comandos de los criterios.
2. **Alcance:** ¿tocó algo de "No incluye" o fuera de la tarea? ¿Hay cambios sin explicar en el diff?
3. **Tests:** ¿cubren el cambio y el caso de error? ¿Fallarían si el código estuviera mal (probá romper una línea si dudás)? ¿Hay tests borrados, deshabilitados, debilitados o sin asserts? ¿Bajó la cobertura o el umbral?
4. **Corrección:** bugs, casos borde, nulls, transacciones, manejo de errores, concurrencia.
5. **Seguridad:** secretos, `.env`, validación de entrada, autorización, datos sensibles en logs o en la consola del navegador.
6. **Convenciones:** las de `AGENTS.md` §7, nombres, duplicación, código muerto.
7. **Docs y registro:** README/SETUP si cambió cómo se levanta; tablero, tarea y `STATUS.md` coherentes; título del PR en Conventional Commit; tamaño razonable (< ~400 líneas).

## 4. Publicar la revisión
Con review formal si la cuenta lo permite (`gh pr review N --approve|--request-changes --body-file review.md`); si no (misma cuenta que el autor), como comentario: `gh pr comment N --body-file review.md`. Formato:

```markdown
**Veredicto: APROBADO | CAMBIOS REQUERIDOS | ESCALAR A 🧠/DUEÑO**

### Criterios de aceptación
- ✅/❌ <criterio> — <evidencia: comando + resultado, test, archivo:línea>

### Bloqueantes
1. `archivo:línea` — <problema> — <por qué importa> — <corrección sugerida>

### No bloqueantes (opcionales, máx. 5)
- <nit>

### verify.sh
<resumen de la salida>
```

## 5. Reglas
- Sugerí; **no reescribas el PR** ni pushees commits a la rama.
- No pidas cambios fuera del alcance de la tarea: proponelos como líneas para "📥 Backlog" en la sección de no bloqueantes.
- Concreto y verificable: cada bloqueante con archivo:línea y corrección sugerida.
- **Segunda ronda:** revisá solo lo pedido + regresiones. Si después de 2 rondas sigue sin aprobarse → `ESCALAR`.
- Tarea 🧠 o que toca seguridad, datos o CI → aunque apruebes, indicá que el dueño debe dar el visto bueno.

## 6. Después del veredicto
- `APROBADO`: dejalo listo para el dueño (la política es que **mergea el dueño**, con squash). No mergees.
- La línea en "Últimas sesiones" de `STATUS.md` la agrega el próximo PR que toque el tablero (no commitees a `main`).

## 7. Respuesta final (máx. 5 líneas)
PR · veredicto · bloqueantes (cantidad y el más importante) · próximo paso (quién hace qué). Sugerí abrir una **sesión nueva** para lo que siga (p. ej. «Seguí `docs/agents/implementer.md`» para atender los cambios).
