# T-018 · Fix the 3 react-hooks/exhaustive-deps warnings without changing behavior
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Agente: 🧠 frontera
- Fase: P0 Estabilizar
- Rama: `fix/T-018-hooks-exhaustive-deps` · Depende de: — · Spec/ADR: —
- Revisa: ligero en sesión nueva

## Por qué
`npm run lint` usa `--max-warnings 0`, así que 3 warnings `react-hooks/exhaustive-deps` bastan para que falle (auditoría §3): `src/Components/Doctor/DoctorConfiguration/DoctorConfiguration.jsx:49`, `src/Components/Doctor/PreviousConsultation/PreviousConsultation.jsx:61`, `src/Components/Patient/Turn/NewTurn/NewTurn.jsx:134`. Agregar dependencias a ciegas puede crear loops de requests; por eso es 🧠.

## Objetivo
Los 3 warnings desaparecen y los efectos se ejecutan las mismas veces que hoy.

## Alcance
- Incluye: estabilizar funciones (`useCallback`, mover funciones dentro del efecto) o dependencias correctas; si un caso requiere conservar el comportamiento actual, `// eslint-disable-next-line react-hooks/exhaustive-deps -- <motivo>` con motivo concreto.
- **No incluye:** otros cambios en esos componentes, `.eslintrc.cjs`.

## Leer antes
- Cada efecto señalado y las funciones que usa (rangos: `DoctorConfiguration.jsx` L20-55, `PreviousConsultation.jsx` L35-65, `NewTurn.jsx` L90-140 — no abrir `NewTurn.jsx` completo).

## Archivos previstos
- modificar: los 3 archivos.

## Tests
- Si T-006 ya está mergeada: un test por componente que cuente las llamadas a la API con MSW (1 llamada al montar). Si no, verificación manual en el navegador (pestaña Network: sin requests repetidas) documentada en el PR.

## Criterios de aceptación
- [ ] `npm run lint 2>&1 | grep -c exhaustive-deps` → `0`.
- [ ] Ningún loop de requests (test o evidencia manual).
- [ ] `./scripts/verify.sh client` sin regresiones.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
