# T-015 · Add characterization tests for login and protected endpoints
- Estado: Bloqueada (espera T-001) · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🤖 agente gratuito
- Fase: P0 Estabilizar
- Rama: `test/T-015-auth-characterization-tests` (crearla desde `main` actualizado antes del primer commit) · Depende de: T-001 · Spec/ADR: docs/TESTING.md §4 (caracterización)
- Revisa: 🧠 modelo de frontera (seguridad)

## Por qué
Los flujos críticos 1 y 2 (login por rol, acceso sin token) no tienen tests (auditoría §4.7). T-008/T-009/T-017 van a cambiar seguridad y errores: primero hay que fijar el comportamiento actual.

## Objetivo
Un test de integración documenta cómo responde hoy la API de autenticación, para detectar cambios no intencionales.

## Alcance
- Incluye: `AuthFlowIT` con MockMvc (`@SpringBootTest` + `@AutoConfigureMockMvc`), reutilizando la configuración de Testcontainers de T-001.
- **No incluye:** cambiar código de `src/main` (si algo te parece un bug, anotalo en "Notas" y como línea de backlog; el test fija lo actual).

## Leer antes
- El IT de referencia de T-001 (`server/src/test/java/io/justina/server/HealthCheckIT.java`)
- `server/src/main/java/io/justina/server/controllers/LoginController.java` (L19-50)
- docs/TESTING.md §3 (nombres, AAA)

## Archivos previstos
- crear: `server/src/test/java/io/justina/server/auth/AuthFlowIT.java`

## Tests (casos; el status esperado es el **actual**, verificado en la auditoría)
1. `login_returnsTokenAndRole_forEachSeedRole` (parametrizado: `admin1@admin.com`→ADMIN, `doctor1@doctor.com`→DOCTOR, `juan@patient.com`→PATIENT): 200, `data.token` no vacío, `data.role` correcto, `message` = `Welcome to Justina.io`. La contraseña: leela igual que los `DataLoader*` (o de `SEED_DEFAULT_PASSWORD` si T-008 ya se mergeó).
2. `login_returns401_whenPasswordIsWrong`: 401 y `message` contiene `Bad credentials`.
3. `protectedEndpoint_returns403_withoutToken`: `GET /v1/api/doctors/getAllDoctors` sin header → 403 (comportamiento actual; T-009 puede cambiarlo a 401).
4. `protectedEndpoint_returns200_withValidToken`: mismo endpoint con el token del caso 1 → 200.
5. `login_returns500_whenBodyIsInvalid`: `{"email":"bad","password":"x"}` → 500 (comportamiento actual, **es un bug**: T-017 lo cambia a 400 y actualiza este test). Comentario en el test que lo diga.

## Criterios de aceptación
- [ ] `./mvnw -q test -Dtest='AuthFlowIT'` pasa (5 tests o más).
- [ ] Romper a propósito el login (p. ej. cambiar `"token"` por `"tok"` en `LoginController`) hace fallar el caso 1 (probar y revertir; mencionarlo en el PR).
- [ ] `./scripts/verify.sh server` verde y cobertura no baja.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
