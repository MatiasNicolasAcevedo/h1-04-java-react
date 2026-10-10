# Protocolo: implementar una tarea

Sos el agente implementador. **Una tarea por sesión.** Seguí estos pasos en orden; no te saltees ninguno.

## 1. Orientarte (sin escribir código)
- Leé `AGENTS.md`, `docs/STATUS.md` y `docs/BACKLOG.md`.
- `git status` y `git log --oneline -10`.
- PRs abiertos: `gh pr list --state open` (sin `gh`: MCP de GitHub; mínimo `git ls-remote --heads origin`).

## 2. Primero lo que está en vuelo
- Si un PR tuyo/de agente tiene **cambios pedidos** (comentario `CAMBIOS REQUERIDOS`): hacé checkout de esa rama y andá al paso 6 para atender solo eso.
- Si ya hay **un PR abierto** de una tarea (esperando revisión o merge): no tomes otra. Avisá al usuario qué falta (revisión o merge) y terminá. **Nunca se trabaja en paralelo.**

## 3. Línea de base
- `git switch main && git pull`
- `./scripts/verify.sh` → anotá el resumen. Comparalo con "Salud" de `docs/STATUS.md`: si falla **algo que STATUS no explica**, no empieces nada nuevo: avisá y proponé una tarea que lo arregle.

## 4. Tomar la tarea
- **La primera** de "✅ Listas" (salteando solo las 👤 dueño). Si es 🧠 y sos el agente gratuito: no la tomes; decile al usuario «La próxima tarea es T-NNN y requiere modelo de frontera: abrí una sesión con ese modelo y escribí: Seguí `docs/agents/implementer.md`», y terminá.
- Creá la rama exacta que indica la tarea (`git switch -c <tipo>/T-NNN-slug`).
- Mové la tarea a "🔨 En curso / en revisión" en `docs/BACKLOG.md` y poné `Estado: En curso` en su archivo. Commit `docs(board): start T-NNN` + push (`git push -u origin <rama>`).
- Abrí el **PR en draft** con el template: `gh pr create --draft --title "<tipo>(<alcance>): <descripción>" --body-file .github/pull_request_template.md` y completá "Tarea".

## 5. Contexto mínimo
- Leé el archivo de la tarea y **solo** lo que indican "Leer antes" y "Archivos previstos", por rangos de líneas.
- No abras `docs/archive/`, auditorías, lockfiles, `node_modules/`, `target/`, `dist/` ni `client/src/Assets/` salvo que la tarea lo pida.

## 6. Implementar con tests
- Respetá "Alcance" y sobre todo "**No incluye**".
- Bugfix: primero el test que reproduce el bug y falla; después el fix.
- Tests de la sección "Tests", copiando el estilo del ejemplo de referencia (`docs/TESTING.md` §3).
- Entre pasos corré el test más específico (`./mvnw -q test -Dtest='X'` / `npx vitest run <archivo>`); al final `./scripts/verify.sh`.
- Commits atómicos, Conventional Commits, footer `Refs: T-NNN`. Push frecuente.

## 7. Contexto de la sesión
- Si la sesión se alarga (ver `AGENTS.md` § Gestión de contexto): completá "Notas de implementación" (hecho / pendiente / próximo paso), commit y push, y sugerí al usuario: `/compress` (Qwen Code) o `/compact Conservar: tarea T-NNN, rama y PR, decisiones, archivos modificados, estado de verify y próximo paso. Descartar: logs y contenido de archivos ya procesados.` → «después escribime "seguí con T-NNN"».

## 8. Reglas duras
- No edites los criterios de aceptación para que pasen.
- No borres, saltees, deshabilites ni debilites tests; no bajes umbrales de cobertura.
- No cambies versiones mayores, arquitectura, seguridad ni CI sin una tarea que lo pida.
- No toques secretos ni `.env`; no copies contraseñas del seed en docs.
- No commitees a `main`. No mergees.
- Trabajo extra descubierto → una línea nueva en "📥 Backlog", no "de paso".

## 9. Escalar en vez de insistir
Si pasa algo de esto: **2 intentos fallidos sobre lo mismo**, hace falta una decisión de diseño, o hay que tocar algo fuera del alcance:
1. Commiteá lo sano (o revertí lo roto).
2. "Notas de implementación": qué probaste, qué falló, qué falta decidir.
3. Mové la tarea a "⛔ Bloqueadas" con `requiere: 🧠 frontera` o `requiere: dueño`.
4. Dejá el PR en draft con un comentario que lo explique. Terminá.

## 10. Cerrar
- Marcá los criterios de aceptación uno por uno en el archivo de la tarea.
- Completá "Notas de implementación" y "Resultado" (PR, qué cambió, tests, pendientes).
- Tablero: tarea a "🏁 Hecho reciente" con el número de PR (si hay > 10 ahí, mové las más viejas a `docs/archive/tasks/`).
- `docs/STATUS.md`: fecha, modelo, Salud (verify, cobertura), **Próximo paso exacto**, una línea en "Últimas sesiones" (si hay > 5, mové la más vieja a `docs/archive/log/AAAA-MM.md`).
- Push. Descripción del PR completa (resumen de `verify.sh`, capturas desktop + mobile si hay UI) y `gh pr ready <N>`. Indicá quién revisa (campo "Revisa" de la tarea).

## 11. Respuesta final (máx. 5 líneas)
Tarea · PR · verify y cobertura · quién revisa · qué sigue. Y terminá con:
«Para revisar, abrí una sesión nueva y escribí: Seguí `docs/agents/reviewer.md` para el PR #N».
