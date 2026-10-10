# T-017 · Return 400/404 for validation and unknown routes without leaking internals
- Estado: Bloqueada (espera T-015) · Prioridad: P0 · Esfuerzo: M · Agente: 🤖 ligero
- Fase: P0 Estabilizar
- Rama: `fix/T-017-error-responses` · Depende de: T-001, T-015 · Spec/ADR: —
- Revisa: frontera (seguridad: fuga de detalles)

## Por qué
`handler/GlobalExceptionHandler.java:23-29` convierte toda excepción no prevista en 500 con `details = ex.getMessage()`: un body inválido en `/v1/api/auth/login` devuelve 500 con el mensaje interno de Spring, y una ruta inexistente (`GET /v1/api/doctors`) devuelve 500 (auditoría §4.3, §4.6).

## Objetivo
Validación inválida → 400 con la lista de campos y mensajes; ruta inexistente → 404; cualquier otro error → 500 **sin** `details` (el detalle va al log).

## Alcance
- Incluye: en `GlobalExceptionHandler`, handlers para `MethodArgumentNotValidException` (400, `errors: [{field, message}]`), `HandlerMethodValidationException` (400) y `NoResourceFoundException` (404); quitar `details` del handler genérico y loguear la excepción con SLF4J; actualizar el caso 5 de `AuthFlowIT` (500 → 400).
- **No incluye:** migrar a `ProblemDetail` (backlog P1), quitar los try/catch de los controllers, cambiar mensajes existentes de otros handlers.

## Leer antes
- `server/src/main/java/io/justina/server/handler/GlobalExceptionHandler.java` (todo, ~60 líneas)
- `server/src/test/java/io/justina/server/auth/AuthFlowIT.java` (de T-015)
- docs/TESTING.md §4 (bugfix: primero el test)

## Archivos previstos
- modificar: `GlobalExceptionHandler.java`, `AuthFlowIT.java` · crear: `server/src/test/java/io/justina/server/handler/GlobalExceptionHandlerIT.java`

## Tests (primero, deben fallar)
1. `POST /v1/api/auth/login` con `{"email":"bad","password":"x"}` → 400 y `errors` incluye `email`.
2. `GET /v1/api/doctors` (con token válido) → 404.
3. Un error inesperado → 500 y el JSON **no** tiene `details` (forzarlo con un `@MockBean` de un servicio que lance `RuntimeException`).

## Criterios de aceptación
- [ ] Los 3 tests pasan y fallaban antes del cambio (evidencia en el PR).
- [ ] `curl -s -X POST localhost:8080/v1/api/auth/login -H 'Content-Type: application/json' -d '{"email":"bad","password":"x"}' -w ' %{http_code}'` termina en ` 400` y no contiene `Validation failed for argument`.
- [ ] `./scripts/verify.sh server` verde; cobertura no baja.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
