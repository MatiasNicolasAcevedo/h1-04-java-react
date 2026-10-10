# Estado del proyecto
_Actualizado: 2026-10-10 · por: agente de frontera (Claude) · sesión: auditoría (bootstrap T-000)_

## En una línea
MVP de hackatón que compila y corre en local con PostgreSQL; sin tests reales ni CI, con fallas de seguridad 🔴 y el front apuntando a producción. Harness para agentes en el PR #1.

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
P0 Estabilizar · 0/18 tareas · ver [ROADMAP](ROADMAP.md)

## Foco
- PR abierto: #1 T-000 bootstrap (esperando revisión del dueño).
- **Próximo paso exacto:** después de mergear #1, sesión nueva con `docs/agents/implementer.md`: el agente ligero toma **T-003** (URL de la API); en otra sesión, un modelo de frontera toma **T-001** (tests del back). Máx. 2 PR abiertos.
- Tras el merge de #1: `git tag audit/2026-10-10 <sha-del-merge> && git push origin audit/2026-10-10`.

## Decisiones pendientes del dueño
- Matriz de permisos por rol (bloquea T-009; propuesta en la tarea).
- Rotar las contraseñas seed en Render cuando se mergee T-008 (`SEED_DEFAULT_PASSWORD`).
- ¿Se mantiene la demo pública en Render + Firebase? (P3)
- Licencia del proyecto (equipo de 8 personas).
- ¿Se conserva el chatbot (`react-simple-chatbot`, abandonada)? (P1)
- Confirmar ADR 0001 (solo PostgreSQL + Flyway) y ADR 0003 (camino de Spring Boot).
- ¿Cuenta bot / GitHub App para revisiones formales? (hoy: comentario con veredicto)
- Configurar la protección de `main` (T-011).

## Últimas sesiones (máx. 5; las anteriores → archive/log/AAAA-MM.md)
- 2026-10-10 · Claude (frontera) · auditó T-000 · auditoría inicial, harness (`verify.sh`, `dev.sh`, compose), README verificado, 18 tareas P0 · PR #1
