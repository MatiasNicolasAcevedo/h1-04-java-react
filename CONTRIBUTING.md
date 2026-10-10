# Cómo contribuir

Flujo para personas y agentes. Corto a propósito: si algo no está acá, preguntá en el PR.

## 1. Ramas — GitHub Flow
- `main` siempre en verde y deployable. **Nadie commitea directo a `main`.**
- Una rama corta por tarea, desde `main` actualizado:
  ```bash
  git switch main && git pull && git switch -c feat/T-012-slug-corto
  ```
- Formato: `<tipo>/T-NNN-slug-corto`. Tipos: `feat`, `fix`, `test`, `refactor`, `chore`, `docs`, `ci`, `build`, `perf`.
- Vida corta (idealmente < 2 días). Si `main` avanzó, `git rebase origin/main` antes de pedir revisión (en tu propia rama).

## 2. Commits — Conventional Commits
```
tipo(alcance): descripción en imperativo y minúscula

Cuerpo opcional: el porqué, no el qué.

Refs: T-NNN
```
- Alcance: `server`, `client`, `ci`, `docs`, `board` o el módulo (`auth`, `appointments`, …).
- Atómicos: cada commit compila y tiene sentido solo.
- Cambios incompatibles: `feat(server)!: ...` y footer `BREAKING CHANGE: ...`.
- Prohibido: `wip`, `fix`, `cambios`, `update` a secas.

## 3. Pull requests
- **Un PR por tarea**, chico (orientativo < ~400 líneas sin lockfiles ni generados). Si crece, partí la tarea.
- **El título es un Conventional Commit** (lo valida `.github/workflows/pr-title.yml`): se mergea con **squash** y queda como commit en `main`.
- Se abre **en draft apenas se crea la rama** (la tarea queda tomada y visible) y pasa a *Ready for review* con `./scripts/verify.sh` sin regresiones y la descripción completa.
- Descripción con el template (`.github/pull_request_template.md`): tarea, qué y por qué, cómo se verificó, capturas desktop + mobile si hay UI, riesgos y checklist.
- El PR actualiza tablero (`docs/BACKLOG.md`), archivo de tarea y `docs/STATUS.md`.

## 4. Revisión
Todo PR lo revisa un agente **en una sesión nueva** siguiendo [docs/agents/reviewer.md](docs/agents/reviewer.md). Ejecutores: 🧠 modelo de frontera · 🤖 agente gratuito (IntelliJ) · 👤 dueño (ver `AGENTS.md` §1).

| PR | Implementa | Revisa | Quién lanza la revisión |
|---|---|---|---|
| Tarea 🤖 de esfuerzo S, sin riesgo | 🤖 agente gratuito | 🤖 agente gratuito, **chat nuevo** | 👤 abre el chat nuevo |
| Tarea 🤖 M, o que toca back y front, seguridad, datos, configuración o CI | 🤖 agente gratuito | 🧠 modelo de frontera | 👤 abre una sesión de frontera |
| Tarea 🧠 | 🧠 modelo de frontera | 🧠 sesión nueva o sub-agente (si el dueño lo pide) + 👤 | 👤 |
| Dependabot | bot | 🤖; versión mayor → tarea 🧠 | 👤 |

- La tarea indica en "Revisa" quién revisa, y la respuesta final de quien implementó dice exactamente qué abrir y qué escribir (formato "Traspasos").
- Máximo **2 rondas** de cambios; después se escala a 🧠 o al 👤.
- **Revisión con sub-agente (solo a pedido explícito del dueño para ese PR):** el 🧠 lanza un sub-agente con contexto limpio que sigue `reviewer.md`, publica su veredicto en el PR y, si pide cambios, el 🧠 los corrige en la misma rama y relanza la revisión (máx. 2 rondas; después escala al 👤).
- **Limitación de GitHub:** con la misma cuenta no se puede aprobar formalmente el propio PR. La revisión se publica como **comentario** con veredicto explícito en la primera línea: `APROBADO`, `CAMBIOS REQUERIDOS` o `ESCALAR A 🧠/DUEÑO`. Sin `gh` (🤖), el revisor deja el texto y el 👤 lo pega.

## 5. Merge
- **Squash merge**, solo con CI en verde (sin CI: `verify.sh` sin regresiones respecto de `main`) y revisión `APROBADO`. Borrar la rama después.
- Política: **mergea el 👤 dueño**. Única excepción: el 🧠, cuando el dueño se lo pide explícitamente para ese PR (revisión con sub-agente). Si el pedido no lo dice, no se mergea.
- Ningún agente commitea ni pushea a `main`.

## 6. Protección de `main`
La configura el dueño en GitHub (pasos exactos en [T-011](docs/tasks/T-011-owner-branch-protection.md)): requerir PR, requerir checks de CI, rama actualizada, historia lineal, sin force push, borrar ramas al mergear, solo squash merge.

## 7. Releases
Al cerrar cada fase del [ROADMAP](docs/ROADMAP.md): tag semántico `v0.x.0` y release en GitHub con notas generadas desde los títulos de los PR (`gh release create v0.1.0 --generate-notes`). `v1.0.0` al cerrar P3.

## 8. Dependencias
- Dependabot (`.github/dependabot.yml`, se agrega en T-012 cuando CI esté en verde): Maven, npm y GitHub Actions, semanal, agrupando minor/patch.
- Versiones mayores: nunca en un PR de Dependabot directo; se convierten en tarea 🧠 con su red de tests.

## 9. Configuración de ejemplo
- Todo archivo de configuración con valores por entorno tiene su `.example` commiteado y el archivo real en `.gitignore` (`AGENTS.md` §6).
- Todo cambio que agregue o renombre una variable actualiza, **en el mismo PR**, su `.example`, README/`docs/SETUP.md` y `docker-compose.yml` (si la usa).

## 10. Antes de pedir revisión (checklist rápido)
- [ ] `./scripts/verify.sh` sin regresiones respecto de `main`.
- [ ] Tests del cambio en el mismo PR (bugfix: primero el test que falla). Ver [docs/TESTING.md](docs/TESTING.md).
- [ ] Sin secretos, `.env` ni datos reales; `.example` y docs al día si cambió una variable.
- [ ] Tarea, tablero y `STATUS.md` actualizados.
- [ ] Título del PR en Conventional Commit.
