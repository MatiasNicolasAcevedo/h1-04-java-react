# Roadmap

Fases e hitos. El detalle de tareas está en [BACKLOG.md](BACKLOG.md); el estado, en [STATUS.md](STATUS.md). Al cerrar cada fase: tag `v0.x.0` + release (ver CONTRIBUTING §7).

## P0 · Estabilizar → `v0.1.0`
**Objetivo:** que cualquiera (humano o agente) lo levante, lo verifique y lo cambie con red de seguridad.
**Criterio de salida (verificable):**
- [ ] README paso a paso verificado desde cero, incluido el login desde la pantalla contra el back local.
- [ ] `./scripts/verify.sh` en verde y CI (`ci.yml`) en verde en `main`.
- [ ] Hallazgos 🔴 de seguridad resueltos (registro de admin, credenciales seed, autorización por rol).
- [ ] Infraestructura de tests back + front + E2E, con umbral de cobertura fijado.
- [ ] Caracterización de los flujos críticos 1, 2 y 7 (`docs/TESTING.md` §6).
- [ ] Protección de `main` configurada (T-011).

**Tareas:** T-001 a T-017 (ver tablero).

## P1 · Actualizar → `v0.2.0`
**Objetivo:** dependencias y plataforma vigentes, en pasos chicos protegidos por la red de P0.
**Criterio de salida:** Spring Boot 4.x, Java 21, Node 24, React 19, Vite ≥ 7, ESLint 9; `npm audit` sin high/critical; Dependabot activo; Flyway en lugar de `create-drop`; un solo driver de DB.
**Tareas principales:** ver "Backlog" P1 (Boot 3.5, Boot 4 con OpenRewrite, Vite + React 19, Flyway, limpieza de dependencias, formateadores).

## P2 · Terminar → `v0.3.0`
**Objetivo:** que lo que se ve en pantalla venga del back y funcione.
**Criterio de salida:** sin pantallas con datos mock en los flujos principales; turnos de ejemplo; trasplante cruzado con API; recuperar contraseña; cada feature con su spec en `docs/specs/` y tests de integración/E2E.
**Tareas principales:** specs de agenda, tratamientos, trasplante cruzado y recuperación de contraseña (Backlog P2).

## P3 · Pulir para portfolio → `v1.0.0`
**Objetivo:** pieza de portfolio presentable.
**Criterio de salida:** responsive verificado por E2E en 375/768/1280; accesibilidad básica (axe sin violaciones serias); cobertura ≥ objetivo de TESTING §5; README con capturas propias en `docs/images/`, badges de CI y cobertura, diagrama; demo online estable; licencia definida; release `v1.0.0`.
