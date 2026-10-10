# T-011 · Configure main branch protection (owner)
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Ejecuta: 👤 dueño (no lo hace un agente)
- Fase: P0 Estabilizar
- Rama: — (configuración en GitHub) · Depende de: — (el check `verify` se agrega cuando exista T-007) · Spec/ADR: CONTRIBUTING §6
- Revisa: —

## Por qué
La API de GitHub muestra `main` como protegida, pero las reglas exactas no son visibles para los agentes (auditoría §4.9). El flujo de CONTRIBUTING asume PR obligatorio, CI requerido y squash.

## Pasos (GitHub web)
1. **Settings → General → Pull Requests:** desmarcar *Allow merge commits* y *Allow rebase merging*; dejar solo **Allow squash merging** con *Default commit message* = **Pull request title**. Marcar **Automatically delete head branches**.
2. **Settings → Rules → Rulesets → New branch ruleset** (o editar la regla existente en *Branches*):
   - Nombre `main`, *Enforcement status* **Active**, *Target branches* → *Include default branch*.
   - ✅ **Restrict deletions** · ✅ **Block force pushes** · ✅ **Require linear history**.
   - ✅ **Require a pull request before merging** · *Required approvals*: `0` mientras revisan agentes con la misma cuenta (la revisión va como comentario con veredicto); `1` si se agrega una cuenta bot/App revisora.
   - ✅ **Require status checks to pass** · ✅ *Require branches to be up to date before merging* · agregar los checks **`conventional-title`** (ya existe, de `pr-title.yml`) y **`verify`** (cuando T-007 esté mergeada; `e2e` cuando exista T-010).
   - *Bypass list*: vacía (o solo tu usuario para emergencias).
3. Guardar.

Equivalente por CLI (opcional): `gh api -X PUT repos/MatiasNicolasAcevedo/h1-04-java-react/branches/main/protection --input protection.json` con los mismos valores.

## Criterios de aceptación
- [ ] Un push directo a `main` es rechazado.
- [ ] Un PR sin el check `conventional-title` en verde no se puede mergear.
- [ ] Solo aparece el botón *Squash and merge*.
- [ ] Al mergear, la rama se borra sola.
- [ ] Anotar en `docs/STATUS.md` (próximo PR que toque el tablero) que la protección está activa y qué checks exige.

## Resultado
- Fecha: … · Checks requeridos: … · Notas: …
