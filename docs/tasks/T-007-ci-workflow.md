# T-007 · Add CI workflow running verify on push and PR
- Estado: Bloqueada · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `ci/T-007-ci-workflow` (crearla desde `main` actualizado antes del primer commit) · Depende de: T-001, T-004, T-005, T-018 (verify en verde) · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (sesión nueva, o sub-agente si el dueño lo pide) + 👤 dueño

## Por qué
No hay CI (auditoría §4.8). Agregarlo mientras `verify.sh` falla dejaría `main` en rojo permanente.

## Objetivo
Cada push a `main` y cada PR corren `scripts/verify.sh` en GitHub Actions, con caché de Maven y npm y reportes de cobertura como artefacto.

## Alcance
- Incluye: `.github/workflows/ci.yml`; badge de CI en `README.md`; en STATUS "CI en main".
- **No incluye:** E2E (T-010), deploy, Dependabot (T-012).

## Leer antes
- `scripts/verify.sh` · `.github/workflows/pr-title.yml` (estilo)

## Archivos previstos
- crear: `.github/workflows/ci.yml` · modificar: `README.md` (badge), `docs/STATUS.md`

## YAML propuesto (validar antes de commitear)
```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
permissions:
  contents: read
concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true
jobs:
  verify:
    runs-on: ubuntu-latest
    timeout-minutes: 20
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with: { distribution: temurin, java-version: '21', cache: maven }
      - uses: actions/setup-node@v4
        with: { node-version-file: .nvmrc, cache: npm, cache-dependency-path: client/package-lock.json }
      - run: ./scripts/verify.sh
        env: { VERIFY_LOG_DIR: verify-logs }
      - if: always()
        uses: actions/upload-artifact@v4
        with:
          name: verify-reports
          path: |
            verify-logs/
            server/target/site/jacoco/
            client/coverage/
          if-no-files-found: ignore
```
(Testcontainers usa el Docker que trae `ubuntu-latest`.)

## Tests
- El workflow es la prueba: un PR de prueba con un test roto debe quedar en rojo (probarlo en una rama y descartar el commit).

## Criterios de aceptación
- [ ] El job `verify` corre en este mismo PR y queda en verde.
- [ ] Un commit temporal que rompe un test hace fallar el job (evidencia en el PR; luego se revierte).
- [ ] Artefacto `verify-reports` con `jacoco/` disponible.
- [ ] Badge de CI en el README apuntando a `ci.yml`.
- [ ] Instrucción al dueño en el PR: agregar `verify` como check requerido (T-011).

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: — · Pendientes → nuevas tareas: …
