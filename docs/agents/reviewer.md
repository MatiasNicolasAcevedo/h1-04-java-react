# Protocolo: revisar un PR

**Lo usa:** el ejecutor que indica el campo "Revisa" de la tarea (matriz en `CONTRIBUTING.md` §4). Sos el agente revisor, en una **sesión nueva** (sin el contexto de quien implementó) o como sub-agente. **Un PR por sesión.** El usuario te dice el número `#N` (o la rama).

## 0. ¿Me corresponde?
- Leé el campo "Revisa" de la tarea. Si dice 🧠 y sos el 🤖: **no revises**. Avisá con el formato de "Traspasos" (paso 7: «ejecuta: 🧠 · abrí una sesión nueva de Claude Code y escribí: Seguí `docs/agents/reviewer.md` para el PR #N») y terminá.
- **Modo sub-agente:** si un 🧠 te lanzó como sub-agente, trabajá solo con lo que dice este archivo, el repo y el PR (no asumas nada de la sesión que te lanzó) y devolvé el veredicto con el formato del paso 4.

## 1. Leer
- `AGENTS.md`, `CONTRIBUTING.md`, `docs/TESTING.md`.
- El PR: `gh pr view N` (descripción y comentarios) y el diff completo: `gh pr diff N`.
  - **Sin `gh`:** `git fetch origin <rama>` y `git diff main...origin/<rama>` (la descripción te la pasa el dueño o la ves en GitHub).
- El archivo de la tarea que enlaza el PR (`docs/tasks/T-NNN-*.md`).
- Del código circundante, solo lo necesario para entender el diff (por rangos).

## 2. Verificar vos mismo
- `gh pr checkout N` (sin `gh`: `git switch <rama> && git pull`) y `./scripts/verify.sh`. No confíes solo en lo que dice el PR.
- Estado de CI: `gh pr checks N` (sin `gh`: pestaña *Checks* del PR; si todavía no hay CI, `verify.sh` sin regresiones respecto de `main`).
- Corré los comandos de los criterios de aceptación.

## 3. Revisar, en este orden
1. **Criterios de aceptación:** uno por uno, ¿se cumplen de verdad? ¿Hay un test o comando que lo demuestre?
2. **Alcance y rama:** ¿tocó algo de "No incluye" o fuera de la tarea? ¿Cambios sin explicar? ¿La rama se llama igual que en la tarea?
3. **Tests:** ¿cubren el cambio y el caso de error? ¿Fallarían si el código estuviera mal (probá romper una línea si dudás)? ¿Hay tests borrados, deshabilitados, debilitados o sin asserts? ¿Bajó la cobertura o el umbral?
4. **Corrección:** bugs, casos borde, nulls, transacciones, manejo de errores, concurrencia.
5. **Seguridad:** secretos, `.env`, validación de entrada, autorización, datos sensibles en logs o en la consola del navegador.
6. **Convenciones:** las de `AGENTS.md` §8, nombres, duplicación, código muerto.
7. **Configuración:** `.example`, `docker-compose.yml` y docs al día si cambió una variable (`AGENTS.md` §6); sin secretos.
8. **Docs y registro:** README/SETUP si cambió cómo se levanta; tablero, tarea y `STATUS.md` coherentes; título del PR en Conventional Commit; tamaño razonable (< ~400 líneas).

## 4. Publicar la revisión
Con review formal si la cuenta lo permite (`gh pr review N --approve|--request-changes --body-file review.md`); si no (misma cuenta que el autor), comentario: `gh pr comment N --body-file review.md`. **Sin `gh`:** escribí el texto en tu respuesta para que el dueño lo pegue como comentario. Formato:

```markdown
**Veredicto: APROBADO | CAMBIOS REQUERIDOS | ESCALAR A 🧠/DUEÑO**

### Criterios de aceptación
- ✅/❌ <criterio> — <evidencia: comando + resultado, test, archivo:línea>

### Bloqueantes
1. `archivo:línea` — <problema> — <por qué importa> — <corrección sugerida>

### No bloqueantes (opcionales, máx. 5)
- <nit o propuesta fuera de alcance → línea para "📥 Backlog">

### verify.sh
<resumen de la salida>
```

## 5. Reglas
- Sugerí; **no reescribas el PR** ni pushees commits a la rama.
- No pidas cambios fuera del alcance de la tarea: proponelos como líneas para "📥 Backlog".
- Concreto y verificable: cada bloqueante con `archivo:línea` y corrección sugerida.
- **Segunda ronda:** solo lo pedido + regresiones. Si después de 2 rondas sigue sin aprobarse → `ESCALAR`.
- Tarea 🧠 o que toca seguridad, datos o CI → aunque apruebes, indicá que el dueño debe dar el visto bueno.

## 6. Merge
- Por defecto **mergea el 👤 dueño** (squash). No mergees.
- **Excepción (revisión con sub-agente):** solo si el dueño lo pidió **explícitamente para este PR**, con `APROBADO` y CI en verde (sin CI: `verify.sh` sin regresiones respecto de `main`), el 🧠 hace squash merge y borra la rama. Si el pedido no lo dice, no se mergea.
- Nunca commitees ni pushees a `main`. La línea en "Últimas sesiones" de `STATUS.md` la agrega el próximo PR que toque el tablero.

## 7. Respuesta final (máx. 5 líneas) y traspaso
PR · veredicto · bloqueantes (cantidad y el más importante). Terminá con el formato de "Traspasos" (`AGENTS.md` §1):
- `APROBADO` → «**Próximo paso:** mergear PR #N · **ejecuta: 👤 dueño** · **Qué hacer:** GitHub → PR #N → *Squash and merge* y borrar la rama».
- `CAMBIOS REQUERIDOS` → quien implementó: 🤖 «abrí un chat nuevo del agente de IntelliJ y escribí: Leé `AGENTS.md` y seguí `docs/agents/implementer.md` (cambios pedidos en el PR #N)» · 🧠 «abrí una sesión nueva de Claude Code y escribí: Seguí `docs/agents/implementer.md` (cambios pedidos en el PR #N)».
- `ESCALAR` → 🧠 o 👤, con la frase exacta.
