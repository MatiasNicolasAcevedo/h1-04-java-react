# T-001 · Set up server test infrastructure (Testcontainers + JaCoCo)
- Estado: Lista · Prioridad: P0 · Esfuerzo: M · Agente: 🧠 frontera
- Fase: P0 Estabilizar
- Rama: `test/T-001-server-test-infrastructure` · Depende de: — · Spec/ADR: [ADR 0002](../adr/0002-testcontainers-postgresql-for-tests.md)
- Revisa: ligero (segunda mirada) + dueño

## Por qué
`./scripts/verify.sh server` falla: el único test (`ServerApplicationTests.contextLoads`) necesita una base y variables de entorno (`Cannot load driver class: ${DB_DRIVER_CLASS_NAME}`, auditoría §3). No hay cobertura medida ni un test de integración de referencia para las tareas 🤖.

## Objetivo
`./scripts/verify.sh server` en verde en una máquina limpia con Docker (sin `server/.env`), con JaCoCo midiendo cobertura y un umbral fijado en la línea de base.

## Alcance
- Incluye: dependencias de test (`spring-boot-testcontainers`, `org.testcontainers:postgresql`, `org.testcontainers:junit-jupiter`, versiones del BOM de Boot); configuración de test con valores ficticios; `@ServiceConnection` PostgreSQL 16; plugin JaCoCo (`prepare-agent`, `report`, `check` en `verify`); un `*IT` de referencia (p. ej. `HealthCheckIT`: `GET /v1/api/render/health` → 200 y texto esperado, y login de un usuario seed → 200 con `token`).
- **No incluye:** cambiar código de `src/main` (salvo que sea imprescindible y se justifique), seguridad, versiones de Spring Boot, CI (T-007).

## Leer antes
- `server/pom.xml` (dependencias y `<build>`, ~L31-140)
- `server/src/main/resources/application.properties` (todo, 32 líneas)
- `server/src/test/java/io/justina/server/ServerApplicationTests.java`
- docs/TESTING.md §1, §3, §5 · ADR 0002

## Archivos previstos
- modificar: `server/pom.xml`, `ServerApplicationTests.java`
- crear: `server/src/test/resources/application-test.properties`, `server/src/test/java/io/justina/server/TestcontainersConfiguration.java` (o equivalente), `server/src/test/java/io/justina/server/HealthCheckIT.java`
- docs: `docs/TESTING.md` (archivos de referencia reales), `docs/STATUS.md` (cobertura de base)

## Tests
- `contextLoads` en verde con Testcontainers (cubre el flujo crítico 7: arranque con seed).
- `HealthCheckIT`: health 200; login seed 200 con token; login con contraseña incorrecta 401.

## Pasos sugeridos
1. Agregar dependencias de Testcontainers y el plugin JaCoCo (versión estable actual, ≥ 0.8.12).
2. `application-test.properties`: `DB_DRIVER_CLASS_NAME`, `DB_DIALECT` (PostgreSQL), `SECRET` (Base64 ficticio ≥ 32 bytes), `MAIL_*`, `CLOUDINARY_*` ficticios. `DB_URL/USER/PASSWORD` los pone `@ServiceConnection`.
3. Configuración de test compartida con `@ServiceConnection PostgreSQLContainer("postgres:16-alpine")` y `@ActiveProfiles("test")`.
4. Comprobar que los tests **no** dependen de `server/.env` (correr con y sin ese archivo; ver T-002, que lo importa desde `application.properties`).
5. Medir cobertura (`target/site/jacoco/index.html`), fijar el umbral `LINE` del `check` en la línea de base redondeada hacia abajo.
6. Actualizar TESTING.md (referencias reales) y STATUS.md (cobertura de base).

## Criterios de aceptación
- [ ] `./scripts/verify.sh server` → `server: ✅ build ✅ tests (N run, 0 failed, 0 errors, …)` sin `server/.env`.
- [ ] `./mvnw -B -q verify` genera `server/target/site/jacoco/jacoco.xml` y falla si la cobertura baja del umbral (probado bajando el umbral a mano y volviendo).
- [ ] `HealthCheckIT` cubre health, login OK y login 401.
- [ ] TESTING.md y STATUS.md actualizados con la cobertura de base y el umbral.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
