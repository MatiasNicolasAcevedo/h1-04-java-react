# T-009 · Enforce role-based authorization on all endpoints
- Estado: Bloqueada (decisión del dueño) · Prioridad: P0 · Esfuerzo: L · Agente: 🧠 frontera
- Fase: P0 Estabilizar
- Rama: `fix/T-009-role-based-authorization` · Depende de: T-008, T-015 · Spec/ADR: matriz abajo (pasa a `docs/specs/authorization.md` al confirmarse)
- Revisa: ligero (segunda mirada) + **dueño**

## Por qué
🔴 El back solo exige "autenticado": un PACIENTE obtiene 200 en `GET /v1/api/users/getAllUsers` y `GET /v1/api/patients/getAllPatients` (probado con curl, auditoría §4.6). Datos médicos y personales expuestos a cualquier usuario.

## Objetivo
Cada endpoint aplica la matriz de permisos confirmada por el dueño, cubierta por tests.

## Matriz propuesta (confirmar o corregir; bloquea la tarea)
| Recurso | ADMIN | DOCTOR | PATIENT |
|---|---|---|---|
| users (listar, editar otros, borrar) | ✅ | ❌ | ❌ |
| users/{id} propio (ver, editar email/password) | ✅ | ✅ solo propio | ✅ solo propio |
| doctors (listar, ver) | ✅ | ✅ | ✅ |
| doctors (crear, editar, desactivar) | ✅ | editar solo propio | ❌ |
| patients (listar todos) | ✅ | ✅ | ❌ |
| patients/{id} (ver, archivos, historia) | ✅ | ✅ | ✅ solo propio |
| patients (crear, desactivar) | ✅ | ❌ | ❌ |
| patients (historia clínica, patologías) | ✅ | ✅ | ❌ |
| appointments (crear) | ✅ | ✅ | ✅ solo para sí |
| appointments (ver por doctor/paciente) | ✅ | ✅ propios | ✅ propios |
| treatments, medical-prescriptions (crear/editar) | ✅ | ✅ | ❌ (solo ver propios) |
| medications, laboratories, financiers, institutions (ver) | ✅ | ✅ | ✅ |
| idem (crear/editar/desactivar), roles | ✅ | ❌ | ❌ |

## Alcance
- Incluye: `@EnableMethodSecurity` + `@PreAuthorize` por endpoint (o reglas en `SecurityConfig`), chequeo de "solo propio" en servicios; 401 sin token y 403 con rol incorrecto.
- **No incluye:** cambios de rutas o de contratos, roles sin pantallas (LABORATORY, FINANCIER, …: quedan sin acceso salvo decisión).

## Leer antes
- Matriz confirmada · `SecurityConfig.java` · `controllers/PatientController.java` (por rangos) · tests de T-008 y T-015

## Archivos previstos
- modificar: `SecurityConfig.java`, los 13 controllers (anotaciones), servicios con "solo propio" · crear: `server/src/test/java/io/justina/server/auth/AuthorizationMatrixIT.java` (test parametrizado por fila)
- Si crece > ~400 líneas: partir por recurso (T-009a usuarios/pacientes, T-009b resto).

## Tests
- `AuthorizationMatrixIT`: una fila por (endpoint, rol) con el status esperado; incluye "paciente lee otro paciente → 403".

## Criterios de aceptación
- [ ] Con token de PATIENT: `GET /v1/api/users/getAllUsers` → 403; `GET /v1/api/patients/getPatientById/<otro>` → 403.
- [ ] Sin token cualquier endpoint protegido → 401.
- [ ] `AuthorizationMatrixIT` cubre todas las filas de la matriz; `verify.sh` verde; cobertura no baja.
- [ ] El front sigue funcionando para los 3 roles (login y home de cada uno; E2E de T-010 si ya existe).
- [ ] Matriz final copiada a `docs/specs/authorization.md` y enlazada desde ARCHITECTURE.md.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
