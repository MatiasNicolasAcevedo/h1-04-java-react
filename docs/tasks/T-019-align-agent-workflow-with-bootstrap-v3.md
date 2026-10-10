# T-019 · Align agent workflow and docs with bootstrap prompt v3
- Estado: Hecha · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `docs/T-019-align-bootstrap-v3` (crearla desde `main` actualizado antes del primer commit) · Depende de: — · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (sub-agente con contexto limpio, a pedido explícito del dueño)

## Por qué
El bootstrap (T-000, PR #1) se hizo con una versión anterior del prompt: el ejecutor barato era un agente de terminal con `gh` y su propio comando de compactar, sin traspasos explícitos entre ejecutores ni revisión con sub-agente. La versión vigente (v3) define 🤖 = agente gratuito de IntelliJ IDEA (modelo Qwen, sin `gh` ni `/compact`) y un formato de "Traspasos".

## Objetivo
Docs, protocolos, tareas y configuración de agentes reflejan el modelo de trabajo v3; el 🤖 puede tomar T-003 leyendo solo los docs vivos.

## Alcance
- Incluye: ejecutores 🧠/🤖/👤 y "Traspasos" en `AGENTS.md`, protocolos, `CONTRIBUTING.md`, `STATUS.md`, tareas y plantilla; archivo de contexto del agente de IntelliJ y `docs/SETUP.md`; alternativa sin `gh`; compactar = chat nuevo para el 🤖; revisión con sub-agente; regla de `.example`; `.claude/settings.json`; borrar `.qwen/settings.json`; §7 "Contexto inferido (v3)" en la auditoría; columna "Pantalla que lo usa" en `ARCHITECTURE.md`.
- **No incluye:** código de la aplicación, `docker-compose.yml`, Dockerfiles, `scripts/` ni README (eso es T-020); reescribir el texto histórico de la auditoría (solo se agrega al final).

## Leer antes
- Prompt de bootstrap v3 (adjunto por el dueño en la sesión): "Modelo de trabajo", 3.2, 3.3, 3.6–3.9, 3.11, 3.13.
- `AGENTS.md`, `docs/agents/*.md`, `CONTRIBUTING.md` §4–5.

## Archivos previstos
- modificar: `AGENTS.md`, `CONTRIBUTING.md`, `docs/{SETUP,STATUS,BACKLOG,ARCHITECTURE}.md`, `docs/agents/*.md`, `docs/agents/templates/task.md`, `docs/tasks/T-001..T-018`, `docs/audits/2026-10-10-initial.md` (solo al final), `.claude/settings.json`, `.github/pull_request_template.md`
- crear: `docs/tasks/T-019-*.md`, `docs/tasks/T-020-*.md` · borrar: `.qwen/settings.json`

## Tests
- Solo docs: sin tests. Chequeos por script (links, IDs, tamaños, `git grep`).

## Criterios de aceptación
- [x] `git grep -n -i -E "l[i]gero|q[w]en code|/c[o]mpress" -- ':!docs/audits' ':!docs/archive'` no devuelve resultados (los corchetes evitan que la línea se encuentre a sí misma).
- [x] Links relativos e IDs `T-NNN` de los docs resuelven a archivos existentes (script).
- [x] Tamaños: AGENTS ≤ 150, protocolos ≤ 80, STATUS ≤ 60, BACKLOG ≤ 120, tareas ≤ 80 líneas.
- [x] Las 18 tareas tienen `Ejecuta:` y `Revisa:` con ícono según la matriz de `CONTRIBUTING.md` §4.
- [x] `implementer.md` y `reviewer.md` tienen la alternativa sin `gh` y terminan con el formato de "Traspasos".
- [x] `bash -n scripts/*.sh` sin errores; `./scripts/verify.sh` sin regresiones respecto de `main`.
- [x] Prueba en seco del 🤖 con T-003 < 40 % de ~64K tokens (`wc -c`).

## Notas de implementación
- Hecho: todo el alcance. Archivo de contexto del agente de IntelliJ: ⚠️ no verificado directamente (jetbrains.com bloqueado por el proxy); según la ayuda oficial citada en búsquedas, el chat de AI Assistant lee `.aiassistant/rules/*.md` y los agentes (Junie/ACP) `AGENTS.md` → se creó `.aiassistant/rules/agents.md` (puntero) y la frase de arranque cubre la duda.
- Verificación: script de links/IDs (solo los placeholders `T-NNN-slug` y `T-021` del tablero), `git grep` vacío, tamaños dentro de límites (AGENTS 127, protocolos ≤ 69, STATUS 42, BACKLOG 73, tareas ≤ 73), `bash -n` ok, `verify.sh` igual que `main` (server tests ❌ T-001, lint 87 ❌).
- Prueba en seco 🤖 (T-003): `AGENTS.md` + `STATUS.md` + `BACKLOG.md` + `implementer.md` + T-003 = ~31 KB; con "Leer antes" y los archivos a modificar ~46 KB ≈ 13K tokens ≈ 21 % de 64K. Rama, verificación, PR sin `gh` (link de comparación) y traspaso a 🧠 para la revisión quedan explícitos.

## Resultado
- PR: #2 · Qué cambió: ejecutores 🧠/🤖/👤 y "Traspasos" en AGENTS, protocolos, CONTRIBUTING, STATUS y tareas; alternativa sin `gh`; regla de `.example`; `.claude/settings.json`; `.qwen/` eliminado; `.aiassistant/rules/agents.md`; auditoría §7; endpoints con pantalla · Tests agregados: — · Pendientes → nuevas tareas: T-020
