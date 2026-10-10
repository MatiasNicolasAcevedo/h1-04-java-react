# server/AGENTS.md

Solo lo específico del back. Lo general está en [../AGENTS.md](../AGENTS.md).

- Paquete raíz `io.justina.server`: `config/` (security, jwt, cors, swagger, mail) · `controllers/` · `services/` (+ `impl/`) · `repositories/` · `entities/` · `dtos/{request,response}` · `enumerations/` · `exceptions/` + `handler/GlobalExceptionHandler` · `data/` (seed) · `helpers/` (Cloudinary, imágenes) · `util/`.
- Configuración: `src/main/resources/application.properties`; todos los valores sensibles vienen de variables (`${DB_URL}`, `${SECRET}`, …) definidas en `server/.env` (ver `server/.env.example`, `docs/SETUP.md`).
- Correr: desde `server/`, `./mvnw spring-boot:run "-Dspring-boot.run.arguments=--spring.config.import=optional:file:.env[.properties]"` con la DB levantada.
- Tests: `./mvnw -q test` · uno solo: `./mvnw -q test -Dtest='NombreTest#metodo'` · gate: `../scripts/verify.sh server`.
- Hoy el único test (`ServerApplicationTests`) necesita DB y variables: falla sin ellas (T-001 lo resuelve con Testcontainers).
- Seguridad: endpoints públicos en `config/security/SecurityConfig.java` (`publicEndpoints()`); el resto requiere `Authorization: Bearer <jwt>`. **No hay control por rol** todavía (T-009): no asumas que existe.
- Seed: `data/MasterDataLoader.java` orquesta los `DataLoader*`; las contraseñas de ejemplo están ahí y no se copian en docs.
- Archivos grandes: `services/impl/PatientServiceImpl.java` (346 líneas), `DoctorServiceImpl.java` (276), `controllers/PatientController.java` (230): leé por rangos.
- Swagger UI: http://localhost:8080/swagger-ui/index.html · OpenAPI: `/v3/api-docs` (contrato de la API).
