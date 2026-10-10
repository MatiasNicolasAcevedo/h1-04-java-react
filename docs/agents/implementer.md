# Protocolo: implementar una tarea

**Lo usan:** 🤖 agente gratuito (IntelliJ) y 🧠 modelo de frontera. Sos el agente implementador. **Una tarea por sesión.** Seguí estos pasos en orden; no te saltees ninguno. Los comandos con `gh` tienen su alternativa **sin `gh`** (caso típico del 🤖: solo `git` en la terminal del IDE).

## 1. Orientarte (sin escribir código)
- Leé `AGENTS.md`, `docs/STATUS.md` y `docs/BACKLOG.md`.
- `git status` y `git log --oneline -10`.
- PRs abiertos: `gh pr list --state open`. Sin `gh`: `git fetch origin && git ls-remote --heads origin` (una rama `*/T-NNN-*` que no es `main` = PR abierto o tarea tomada) y "🔨 En curso" del tablero.

## 2. Primero lo que está en vuelo
- Si un PR de tarea tiene **cambios pedidos** (comentario `CAMBIOS REQUERIDOS`) y lo implementó tu tipo de ejecutor: `git switch <rama> && git pull` y andá al paso 6 para atender solo eso.
- Si ya hay **un PR de tarea abierto** esperando revisión o merge: no tomes otra. Avisá con el formato de "Traspasos" (paso 11) quién tiene que revisar (campo "Revisa" de la tarea) o mergear (👤), y terminá. **Nunca se trabaja en paralelo.**

## 3. Línea de base
- `git switch main && git pull`
- `./scripts/verify.sh` → anotá el resumen. Comparalo con "Salud" de `docs/STATUS.md`: si falla **algo que STATUS no explica**, no empieces nada nuevo: avisá y proponé una tarea que lo arregle (traspaso a 🧠).

## 4. Tomar la tarea
- **La primera** de "✅ Listas". **Si no te corresponde** (es 🧠 y sos el 🤖, o es 👤): no la tomes **ni saltees a la siguiente**; avisá con el formato de "Traspasos" (paso 11) y terminá.
- **Antes de cualquier commit**, creá la rama exacta de la tarea: `git switch -c <tipo>/T-NNN-slug`.
- Mové la tarea a "🔨 En curso / en revisión" en `docs/BACKLOG.md` y poné `Estado: En curso` en su archivo. Commit `docs(board): start T-NNN` + `git push -u origin <rama>`.
- **PR en draft** con el template (`.github/pull_request_template.md`), título = Conventional Commit:
  - Con `gh`: `gh pr create --draft --title "<tipo>(<alcance>): <descripción>" --body-file .github/pull_request_template.md` y completá "Tarea".
  - **Sin `gh`:** dale al dueño el link `https://github.com/MatiasNicolasAcevedo/h1-04-java-react/compare/main...<rama>?expand=1`, el **título** y el **cuerpo** (template con "Tarea" completa) listos para pegar, y pedile que lo abra en **draft**. Seguí trabajando: el PR se abre en paralelo.

## 5. Contexto mínimo
- Leé el archivo de la tarea y **solo** lo que indican "Leer antes" y "Archivos previstos", por rangos de líneas.
- No abras `docs/archive/`, auditorías, lockfiles, `node_modules/`, `target/`, `dist/` ni `client/src/Assets/` salvo que la tarea lo pida.

## 6. Implementar con tests
- Respetá "Alcance" y sobre todo "**No incluye**".
- Bugfix: primero el test que reproduce el bug y falla; después el fix.
- Tests de la sección "Tests", copiando el estilo del ejemplo de referencia (`docs/TESTING.md` §3).
- Entre pasos corré el test más específico (`./mvnw -q test -Dtest='X'` / `npx vitest run <archivo>`); al final `./scripts/verify.sh`.
- Si agregás o cambiás una variable de configuración: su `.example`, `docker-compose.yml` y docs en el mismo PR (`AGENTS.md` §6).
- Commits atómicos, Conventional Commits, footer `Refs: T-NNN`. Push frecuente.

## 7. Contexto largo (compactar)
Si la sesión se alarga (`AGENTS.md` §5): completá "Notas de implementación" (hecho / pendiente / próximo paso), commit y push, y decile al usuario:
- 🧠: `/compact Conservar: tarea T-NNN, rama y PR, decisiones, archivos modificados, estado de verify y próximo paso. Descartar: logs y contenido de archivos ya procesados.` → «después escribime "seguí con T-NNN"».
- 🤖 (sin `/compact`, compactar = chat nuevo): «Abrí un chat nuevo del agente de IntelliJ y escribí: Leé `AGENTS.md` y seguí `docs/agents/implementer.md` (retomando T-NNN)».

## 8. Reglas duras
- No edites los criterios de aceptación para que pasen.
- No borres, saltees, deshabilites ni debilites tests; no bajes umbrales de cobertura.
- No cambies versiones mayores, arquitectura, seguridad, CI ni configuración de producción sin una tarea que lo pida.
- No toques secretos ni `.env`; no copies contraseñas del seed en docs.
- No commitees ni pushees a `main`. No mergees.
- Trabajo extra descubierto → una línea nueva en "📥 Backlog", no "de paso".

## 9. Escalar en vez de insistir
Si pasa algo de esto: **2 intentos fallidos sobre lo mismo**, hace falta una decisión de diseño, o hay que tocar algo fuera del alcance:
1. Commiteá lo sano (o revertí lo roto) y push.
2. "Notas de implementación": qué probaste, qué falló, qué falta decidir.
3. Mové la tarea a "⛔ Bloqueadas" con `requiere: 🧠` o `requiere: 👤 dueño`. **La cola queda detenida en esa tarea:** no se toma la siguiente.
4. Comentario en el PR draft que lo explique (sin `gh`: incluilo en tu respuesta para que el dueño lo pegue). Terminá con el traspaso (paso 11), p. ej. «ejecuta: 🧠 · abrí una sesión nueva de Claude Code y escribí: Seguí `docs/agents/implementer.md` para retomar T-NNN».

## 10. Cerrar
- Marcá los criterios de aceptación uno por uno en el archivo de la tarea.
- Completá "Notas de implementación" y "Resultado" (PR, qué cambió, tests, pendientes).
- Tablero: tarea a "🏁 Hecho reciente" con el número de PR (si hay > 10, mové las más viejas a `docs/archive/tasks/`).
- `docs/STATUS.md`: fecha, ejecutor, Salud (verify, cobertura), "Foco" con el traspaso de la revisión, una línea en "Últimas sesiones" (si hay > 5, mové la más vieja a `docs/archive/log/AAAA-MM.md`).
- Push. Descripción del PR completa (resumen de `verify.sh`, capturas 375 y 1280 px si hay UI) y "ready": `gh pr ready <N>`; sin `gh`: pedíselo al dueño junto con el cuerpo final del PR.

## 11. Respuesta final (máx. 5 líneas) y traspaso
Tarea · PR (o link de comparación) · verify y cobertura · quién revisa. Terminá **siempre** con el formato de "Traspasos" (`AGENTS.md` §1), según "Revisa" de la tarea:
> **Próximo paso:** revisar PR #N (T-NNN) · **ejecuta: 🤖 agente gratuito (IntelliJ)** · **Qué hacer:** abrí un chat nuevo del agente de IntelliJ y escribí: «Leé `AGENTS.md` y seguí `docs/agents/reviewer.md` para el PR #N»

o `ejecuta: 🧠 modelo de frontera` · abrí una sesión nueva de Claude Code y escribí: «Seguí `docs/agents/reviewer.md` para el PR #N».
