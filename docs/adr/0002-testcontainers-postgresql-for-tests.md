# 0002 · Testcontainers con PostgreSQL para tests de integración (no H2)

- Estado: **Aceptado** · Fecha: 2026-10-10

## Contexto
El único test (`ServerApplicationTests.contextLoads`) falla sin una base real y variables de entorno. Hace falta una red de tests de integración antes de migrar Spring Boot (ver auditoría §4.7).

## Decisión
- Tests `@SpringBootTest` usan **Testcontainers PostgreSQL** (misma versión mayor que producción) con `@ServiceConnection` (Spring Boot ≥ 3.1).
- Las variables no relacionadas con la base (`SECRET`, mail, Cloudinary) se definen con valores de prueba en `src/test/resources/application-test.properties` (o equivalente) sin credenciales reales.
- Los `@WebMvcTest` y unitarios no levantan contenedores.

## Alternativas
- H2 en memoria: rápido, pero otro dialecto; oculta errores de SQL/tipos de PostgreSQL.
- Base compartida de CI: frágil y dependiente del orden.

## Consecuencias
- Docker es requisito para `verify.sh` (ya lo es para desarrollo local). GitHub Actions `ubuntu-latest` trae Docker.
- Primer arranque más lento (descarga de imagen); se reutiliza el contenedor entre tests de la misma JVM.
- Tarea: T-001.
