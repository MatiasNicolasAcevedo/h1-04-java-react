# Justina.io · server

API REST en Spring Boot 3.3 (Java 17+) con Spring Security + JWT, JPA/Hibernate y PostgreSQL. Documentada con OpenAPI (Swagger UI).

Proyecto completo y paso a paso del entorno entero: [README raíz](../README.md).

## Correr solo el back

Requisitos: Java 21 (o 17+) y Docker. El primer paso es desde la raíz del repo; el resto desde `server/`.

**1. Variables y base de datos** (desde la raíz del repo).

```bash
cp server/.env.example server/.env
```

```bash
docker compose up -d --wait db
```

Resultado esperado: `Container justina-db Healthy`.

**2. Arrancar** (desde `server/`).

```bash
./mvnw spring-boot:run "-Dspring-boot.run.arguments=--spring.config.import=optional:file:.env[.properties]"
```

Resultado esperado: `Started ServerApplication in ... seconds`. Comprobalo con:

```bash
curl http://localhost:8080/v1/api/render/health
```

Debe responder `Server is awake and running!`. Swagger UI: http://localhost:8080/swagger-ui/index.html.

**3. Verificar** (desde `server/`).

```bash
../scripts/verify.sh server
```

Resultado esperado: `server: ✅ build ✅ tests (...)` y `RESULT: ✅ PASS`. ⚠️ Hoy falla: el test necesita una base de datos ([T-001](../docs/tasks/T-001-server-test-infrastructure.md)).

## Comandos

| Comando (desde `server/`) | Qué hace |
|---|---|
| `./mvnw spring-boot:run "-Dspring-boot.run.arguments=..."` | Arranca la API en el puerto 8080 (ver paso 2) |
| `./mvnw -q -DskipTests package` | Genera `target/server-0.0.1-SNAPSHOT.jar` |
| `./mvnw -q test` | Corre los tests |
| `./mvnw -q test -Dtest='NombreTest#metodo'` | Corre un solo test |
| `./mvnw -B -q clean verify` | Lo que corre `verify.sh` |

En Windows (PowerShell/CMD) usá `.\mvnw.cmd` en lugar de `./mvnw`.

## Estructura

```
src/main/java/io/justina/server/
  config/        seguridad (SecurityConfig, AppConfig), jwt/, CORS, Swagger, mail
  controllers/   endpoints REST bajo /v1/api/**
  services/      interfaces + impl/ con la lógica de negocio
  repositories/  Spring Data JPA
  entities/      modelo JPA (User, Patient, Doctor, Appointment, Treatment, ...)
  dtos/          request/ y response/
  data/          carga de datos de ejemplo al arrancar
  exceptions/, handler/   excepciones propias y manejo global
src/main/resources/application.properties   configuración (valores por variables de entorno)
```

Variables de entorno: [docs/SETUP.md](../docs/SETUP.md#variables-de-entorno). Deploy: `Dockerfile` (Render). Contexto para agentes: [AGENTS.md](AGENTS.md).
