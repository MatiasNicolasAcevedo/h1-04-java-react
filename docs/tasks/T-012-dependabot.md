# T-012 · Enable Dependabot for Maven, npm and GitHub Actions
- Estado: Bloqueada (espera T-007: CI en verde) · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🤖 agente gratuito
- Fase: P0 Estabilizar
- Rama: `ci/T-012-dependabot` (crearla desde `main` actualizado antes del primer commit) · Depende de: T-007 · Spec/ADR: CONTRIBUTING §8
- Revisa: 🧠 modelo de frontera (toca CI)

## Por qué
No hay actualización automática de dependencias y `npm audit` reporta 24 high (auditoría §4.2, §4.8). Sin CI en verde, los PR de Dependabot no se podrían evaluar.

## Objetivo
Dependabot abre, una vez por semana, PRs agrupados de minor/patch para `server/` (Maven), `client/` (npm) y GitHub Actions.

## Alcance
- Incluye: `.github/dependabot.yml`; nota en CONTRIBUTING §8 si cambia algo.
- **No incluye:** mergear PRs de Dependabot, subir versiones a mano, versiones mayores (las ignora este config: van como tareas 🧠).

## Leer antes
- CONTRIBUTING.md §8 · este archivo (YAML propuesto)

## Archivos previstos
- crear: `.github/dependabot.yml`

## YAML propuesto
```yaml
version: 2
updates:
  - package-ecosystem: maven
    directory: /server
    schedule: { interval: weekly, day: monday }
    open-pull-requests-limit: 3
    commit-message: { prefix: "build(server)" }
    groups:
      server-minor-patch: { update-types: [minor, patch] }
    ignore:
      - dependency-name: "*"
        update-types: ["version-update:semver-major"]
  - package-ecosystem: npm
    directory: /client
    schedule: { interval: weekly, day: monday }
    open-pull-requests-limit: 3
    commit-message: { prefix: "build(client)" }
    groups:
      client-minor-patch: { update-types: [minor, patch] }
    ignore:
      - dependency-name: "*"
        update-types: ["version-update:semver-major"]
  - package-ecosystem: github-actions
    directory: /
    schedule: { interval: weekly, day: monday }
    commit-message: { prefix: "ci" }
```

## Tests
- No aplica (configuración). Validar sintaxis: `python3 -c "import yaml; yaml.safe_load(open('.github/dependabot.yml'))"`.

## Criterios de aceptación
- [ ] El comando de validación no da error.
- [ ] Tras el merge, *Insights → Dependency graph → Dependabot* muestra los 3 ecosistemas sin errores (lo comprueba el dueño).
- [ ] Los títulos que genera cumplen Conventional Commits (prefijos `build(server)`, `build(client)`, `ci`).

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: — · Pendientes → nuevas tareas: …
