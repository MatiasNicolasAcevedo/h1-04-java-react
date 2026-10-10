# Protocolo: auditoría periódica

**Lo usa: solo 🧠 modelo de frontera.** Si sos el 🤖 agente gratuito, no audites: avisá con el formato de "Traspasos" (`AGENTS.md` §1: «ejecuta: 🧠 · abrí una sesión nueva de Claude Code y escribí: Seguí `docs/agents/auditor.md`») y terminá.

Sos el agente auditor. Se hace cada 5–10 PR mergeados, antes de un cambio grande (p. ej. migrar Spring Boot) o cuando hay 2+ tareas bloqueadas por `🧠`.

**Puntos de control:** al terminar cada bloque (A, B, C) persistí en archivos, commit y push. Si el contexto está cargado entre bloques, detenete y sugerí: `/compact Conservar: auditoría AAAA-MM-DD en curso, bloque X terminado, rama y PR, decisiones y próximo paso según docs/STATUS.md. Descartar: salidas de comandos y archivos ya volcados.` → «seguí desde el bloque X».

Rama: `docs/audit-AAAA-MM-DD` · PR en draft desde el primer commit: `docs: periodic audit AAAA-MM-DD`.

## Bloque A · Qué pasó
1. Leé `AGENTS.md`, `docs/STATUS.md`, `docs/BACKLOG.md`, `docs/ROADMAP.md`, `docs/TESTING.md` y la última auditoría de `docs/audits/`.
2. Cambios desde la última: `git log --oneline audit/<fecha-anterior>..main` y `git diff --stat audit/<fecha-anterior>..main` (la primera vez: desde el merge de T-000). PR mergeados y sus revisiones: `gh pr list --state merged --limit 20` y `gh pr view N --comments`.
3. **Auditar el trabajo de los agentes:** calidad de lo mergeado; ¿los tests son significativos? (spot check: romper a propósito una línea de lógica cubierta y ver si algún test falla; o PIT/Stryker puntual); ¿los criterios se cumplieron de verdad?; ¿alguna revisión dejó pasar problemas?; cambios fuera de alcance; deuda nueva. Cada corrección → tarea nueva.
→ Persistir: borrador `docs/audits/AAAA-MM-DD-periodic.md` (secciones A), commit, push.

## Bloque B · Salud
4. **Tests y cobertura:** `./scripts/verify.sh` y `./scripts/e2e.sh`; tendencia de cobertura; si creció, **subí el umbral** (JaCoCo / Vitest) en este PR; tests lentos o inestables → tareas; flujos críticos sin E2E (`docs/TESTING.md` §6).
5. **Onboarding:** seguí el paso a paso del README desde cero (sin `.env`, sin `node_modules`, sin `target/`, `docker compose down -v`: está en la lista *deny* de `.claude/settings.json`, pedile al usuario que lo corra o que lo autorice). Corregí lo que falle o sea ambiguo y actualizá la línea "Verificado el …".
6. **Deriva documental:** que `README`, `AGENTS.md`, `CONTRIBUTING.md`, `TESTING.md`, `ARCHITECTURE.md`, `SETUP.md` y los comandos sigan siendo ciertos (versiones, puertos, rutas, IDs de tareas).
7. **Relevamiento liviano:** las 14 dimensiones de la auditoría inicial, **solo en lo que cambió** (incluye `npm audit` y versiones/EOL).
→ Persistir: secciones B en la auditoría, commit, push.

## Bloque C · Replanificar y ajustar
8. **Resolver lo bloqueado:** decisiones pendientes del dueño ya respondidas (escribí el ADR si corresponde) y tareas `🧠` prioritarias. Cada una en su propia rama y PR, idealmente en su propia sesión con `implementer.md`.
9. **Replanificar:** repriorizar; refinar "📥 Backlog" → "✅ Listas" hasta tener 5–10 tareas, la mayoría 🤖, cumpliendo la Definición de Listo (template `docs/agents/templates/task.md`); partir tareas grandes; actualizar `docs/ROADMAP.md`; si se cerró una fase, proponer release (`v0.x.0`).
10. **Ajustar el sistema:** si el 🤖 agente gratuito o el revisor fallaron repetidamente en algo, o las sesiones tuvieron que compactar seguido (señal de tareas demasiado grandes), mejorá `AGENTS.md`, plantillas o protocolos sin pasar sus límites de tamaño (AGENTS ≤ 150 líneas, protocolos ≤ 80, STATUS ≤ 60, BACKLOG ≤ 120).

## Cerrar
- `docs/audits/AAAA-MM-DD-periodic.md` corta: resumen con semáforo, hallazgos nuevos (severidad, evidencia, tarea), cobertura y umbrales, decisiones.
- `docs/STATUS.md` actualizado (salud, próximo paso exacto, línea en "Últimas sesiones"); archivá lo que exceda los límites (`docs/archive/`).
- PR listo para revisión (`docs/agents/reviewer.md`; sub-agente solo si el dueño lo pide). Después del merge (lo hace el dueño o el 🧠 a pedido explícito): `git tag audit/AAAA-MM-DD <sha-del-merge> && git push origin audit/AAAA-MM-DD`.
- Respuesta final (máx. 8 líneas): semáforo, top 3 hallazgos, tareas nuevas en Listas, qué tiene que decidir el dueño. Terminá con el formato de "Traspasos" para la primera de la cola (p. ej. «**Próximo paso:** T-NNN · <título> · **ejecuta: 🤖 agente gratuito (IntelliJ)** · **Qué hacer:** abrí un chat nuevo del agente de IntelliJ y escribí: Leé `AGENTS.md` y seguí `docs/agents/implementer.md`»).
