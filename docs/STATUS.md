# Estado del proyecto
_Actualizado: 2026-10-10 · por: 🧠 modelo de frontera (Claude Code) · sesión: implementación T-019_

## En una línea
MVP de hackatón que compila y corre en local con PostgreSQL; sin tests reales ni CI, con fallas de seguridad 🔴 y el front apuntando a producción. Harness para agentes mergeado (PR #1) y alineado con el prompt de bootstrap v3 (T-019, PR #2).

## Salud
| Check | Estado | Nota |
|---|---|---|
| verify.sh | ❌ | server: test sin DB → T-001 · client: lint 87 problemas → T-004, T-005, T-018 · builds ✅ |
| CI en main | sin CI | → T-007 (solo `pr-title.yml` tras el merge de T-000) |
| Levantar en local (README) | ✅ verificado 2026-10-10 (DB + back + front) | login desde la pantalla en local ❌ → T-003 |
| Cobertura back / front | ⚠️ no medida / sin tests | el umbral se fija en T-001 / T-006 |
| E2E smoke | no existe | → T-010 |
| Dependencias vulnerables | npm: 0 critical, 24 high | → backlog P1 |
| Seguridad | 🔴 3 críticos | registro admin público y credenciales seed → T-008 · sin authz por rol → T-009 |
| Última auditoría | 2026-10-10 | [initial](audits/2026-10-10-initial.md) |

## Fase actual
P0 Estabilizar · 1/20 tareas · ver [ROADMAP](ROADMAP.md)

## Foco
- PR de tarea abierto (máx. 1): ninguno.
- **Próximo paso:** T-003 · URL de la API desde `VITE_API_URL` · **ejecuta: 🤖 agente gratuito (IntelliJ)**
- **Qué hacer:** abrí un chat nuevo del agente de IntelliJ (modo agente) y escribí: «Leé `AGENTS.md` y seguí `docs/agents/implementer.md`»
- **Después:** T-002 (🤖) → T-020 (🧠) → T-014 (🤖) _(revisión de T-003 y T-002: 🧠, ver "Revisa" de cada tarea)_

## Decisiones pendientes del dueño
- Matriz de permisos por rol (bloquea T-009; propuesta en la tarea).
- ¿Se conservan los botones de login demo que autocompletan credenciales? (afecta T-008)
- Rotar las contraseñas seed en Render cuando se mergee T-008 (`SEED_DEFAULT_PASSWORD`).
- ¿Se mantiene la demo pública en Render + Firebase? (P3)
- Licencia del proyecto (equipo de 8 personas).
- ¿Se conserva el chatbot (`react-simple-chatbot`, abandonada)? (P1)
- Confirmar ADR 0001 (solo PostgreSQL + Flyway) y ADR 0003 (camino de Spring Boot).
- ¿Cuenta bot / GitHub App para revisiones formales? (hoy: comentario con veredicto)
- Confirmar el archivo de reglas del agente de IntelliJ (`.aiassistant/rules/agents.md`, tipo *Always*) y qué agente usás (chat de AI Assistant o Junie): ver `docs/SETUP.md` § Agentes.
- Configurar la protección de `main` (T-011).

## Últimas sesiones (máx. 5; las anteriores → archive/log/AAAA-MM.md)
- 2026-10-10 · 🧠 Claude Code · implementó T-019 · docs y protocolos alineados con v3 (ejecutores, traspasos, sin `gh`), T-020 especificada · PR #2 (revisión con sub-agente a pedido del dueño)
- 2026-10-10 · Claude (frontera) · auditó T-000 · auditoría inicial, harness (`verify.sh`, `dev.sh`, compose), README verificado, 18 tareas P0 · PR #1 (revisado y mergeado por Claude a pedido del dueño)
