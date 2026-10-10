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
Todo PR lo revisa un agente **en una sesión nueva** siguiendo [docs/agents/reviewer.md](docs/agents/reviewer.md):

| PR | Implementa | Revisa |
|---|---|---|
| Tarea 🤖 de esfuerzo S, sin riesgo | ligero | ligero en sesión nueva |
| Tarea 🤖 M, o que toca back y front, seguridad, datos o CI | ligero | frontera |
| Tarea 🧠 | frontera | ligero en sesión nueva (segunda mirada) + dueño |
| Dependabot | bot | ligero; si es versión mayor → tarea 🧠 |

- Máximo **2 rondas** de cambios; después se escala a frontera o al dueño.
- **Limitación de GitHub:** con la misma cuenta no se puede aprobar formalmente el propio PR. La revisión se publica como **comentario** con veredicto explícito en la primera línea: `APROBADO`, `CAMBIOS REQUERIDOS` o `ESCALAR`. Con una cuenta bot o GitHub App de revisión se usa una review formal.

## 5. Merge
- **Squash merge**, solo con CI en verde y revisión `APROBADO`.
- Política: **mergea el dueño** del repo. Los agentes nunca mergean.
- Borrar la rama después del merge.

## 6. Protección de `main`
La configura el dueño en GitHub (pasos exactos en [T-011](docs/tasks/T-011-owner-branch-protection.md)): requerir PR, requerir checks de CI, rama actualizada, historia lineal, sin force push, borrar ramas al mergear, solo squash merge.

## 7. Releases
Al cerrar cada fase del [ROADMAP](docs/ROADMAP.md): tag semántico `v0.x.0` y release en GitHub con notas generadas desde los títulos de los PR (`gh release create v0.1.0 --generate-notes`). `v1.0.0` al cerrar P3.

## 8. Dependencias
- Dependabot (`.github/dependabot.yml`, se agrega en T-012 cuando CI esté en verde): Maven, npm y GitHub Actions, semanal, agrupando minor/patch.
- Versiones mayores: nunca en un PR de Dependabot directo; se convierten en tarea 🧠 con su red de tests.

## 9. Antes de pedir revisión (checklist rápido)
- [ ] `./scripts/verify.sh` sin regresiones respecto de `main`.
- [ ] Tests del cambio en el mismo PR (bugfix: primero el test que falla). Ver [docs/TESTING.md](docs/TESTING.md).
- [ ] Sin secretos, `.env` ni datos reales.
- [ ] Tarea, tablero y `STATUS.md` actualizados.
- [ ] Título del PR en Conventional Commit.
