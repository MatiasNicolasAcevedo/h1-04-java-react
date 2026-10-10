# Setup detallado

Complementa el [paso a paso del README](../README.md#paso-a-paso); no lo repite.

## Variables de entorno

### Back (`server/.env`, copiado de `server/.env.example`)

| Nombre | Para qué | Valor local | Obligatoria |
|---|---|---|---|
| `DB_URL` | JDBC de la base | `jdbc:postgresql://localhost:5432/justina` | sí |
| `DB_DRIVER_CLASS_NAME` | Driver JDBC | `org.postgresql.Driver` | sí |
| `DB_USER` / `DB_PASSWORD` | Credenciales de la base | `justina` / `justina` (las de `docker-compose.yml`) | sí |
| `DB_DIALECT` | Dialecto de Hibernate | `org.hibernate.dialect.PostgreSQLDialect` | sí |
| `SECRET` | Clave HMAC del JWT, **Base64 de ≥ 32 bytes** | valor de ejemplo del `.env.example` | sí |
| `MAIL_PORT` / `MAIL_USER` / `MAIL_PASSWORD` | SMTP de Gmail (`spring.mail.*`) | valores ficticios: la app arranca, el envío falla | sí (para arrancar) |
| `CLOUDINARY_NAME` / `CLOUDINARY_API_KEY` / `CLOUDINARY_API_SECRET` | Subida de imágenes | valores ficticios: la subida falla | sí (para arrancar) |

- Cómo se cargan: `application.properties:1` importa `optional:env.properties` **del classpath**, así que un archivo en `server/` no se lee solo. Por eso el arranque pasa `--spring.config.import=optional:file:.env[.properties]` (README paso 5, `scripts/dev.sh`). T-002 lo hace automático.
- Alternativa: exportar las variables en la shell (`set -a; . ./.env; set +a` desde `server/`) y correr `./mvnw spring-boot:run` sin argumentos.
- Generar un `SECRET` propio: `openssl rand -base64 48`.
- Para emails reales con Gmail hace falta una *contraseña de aplicación* de la cuenta. Para imágenes, una cuenta de Cloudinary.

### Front
Hoy no usa variables (URL de la API fija). T-003 agrega `VITE_API_URL` en `client/.env.example`.

## Correr sin Docker

Con un PostgreSQL 16 instalado localmente:

```bash
sudo -u postgres psql -c "CREATE USER justina WITH PASSWORD 'justina';" -c "CREATE DATABASE justina OWNER justina;"
```

y usar el mismo `server/.env`. Con MySQL 8 también funciona cambiando `DB_URL` (`jdbc:mysql://localhost:3306/justina`), `DB_DRIVER_CLASS_NAME` (`com.mysql.cj.jdbc.Driver`) y `DB_DIALECT` (`org.hibernate.dialect.MySQLDialect`) — ⚠️ no verificado (la base de producción es PostgreSQL).

## Datos de ejemplo
- `spring.jpa.hibernate.ddl-auto=create-drop`: **cada arranque borra y recrea el esquema** y vuelve a cargar el seed (`server/.../data/`). Para "resetear datos", reiniciá el back.
- Usuarios: `admin1..5@admin.com`, `doctor1@doctor.com` (y otros doctores), `juan@patient.com`, `maria@patient.com`, `carlos@patient.com`, … Contraseñas: en `DataLoaderAdmin.java`, `DataLoaderDoctor.java` y `DataLoaderPatient.java` (línea con `passwordEncoder.encode`).
- No hay turnos de ejemplo (loader comentado).

## IDE
- **IntelliJ IDEA:** abrir `server/` como proyecto Maven; SDK 21; habilitar *annotation processing* (Lombok). Run configuration de `ServerApplication` con *Environment variables* tomadas de `server/.env` (IntelliJ permite cargar un `.env` con el plugin EnvFile) o con *Program arguments* `--spring.config.import=optional:file:.env[.properties]` y *Working directory* `server/`.
- **VS Code:** extensiones *Extension Pack for Java*, *Spring Boot Extension Pack*, *ESLint*, *Tailwind CSS IntelliSense*, *EditorConfig*. Para el back, en `launch.json`: `"args": "--spring.config.import=optional:file:.env[.properties]"`, `"cwd": "${workspaceFolder}/server"`.

## Debugging
- Back con debugger remoto: `./mvnw spring-boot:run "-Dspring-boot.run.jvmArguments=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005" "-Dspring-boot.run.arguments=--spring.config.import=optional:file:.env[.properties]"` y conectar el IDE al puerto 5005.
- Logs: `application.properties` ya tiene DEBUG para web, Jackson y Security (mucho ruido). Logs de `dev.sh` en `.dev-logs/`.
- Front: React DevTools; la sesión está en `localStorage["authData"]`.

## Agente ligero (Qwen Code u otros)
- **Qwen Code:** `.qwen/settings.json` define `context.fileName: ["AGENTS.md"]` (clave verificada en `@qwen-code/qwen-code` 0.25.0), así lee `AGENTS.md` como archivo de contexto. Arrancá con `qwen` desde la raíz y escribí `Seguí docs/agents/implementer.md`. Compactar: `/compress`.
- **opencode / Cline / Codex:** leen `AGENTS.md` de forma nativa. **Aider:** `aider --read AGENTS.md`.
- **Contexto efectivo supuesto:** ~64K tokens. Las tareas 🤖 están dimensionadas para usar < 40 %.
- **GitHub:** preferido `gh` CLI autenticado (`gh auth login`); alternativa: MCP de GitHub; mínimo: `git push` + abrir el PR desde la web. Con una sola cuenta no se puede aprobar el propio PR: la revisión se publica como comentario con veredicto (ver `CONTRIBUTING.md`). Opcional: una cuenta bot o GitHub App solo para revisar.
- **Claude Code:** `.claude/settings.json` permite sin preguntar los comandos seguros (verify, tests, lint, git de lectura, `gh pr view/list/diff`).

## Problemas del entorno
Ver la tabla del [README](../README.md#problemas-frecuentes). Además:
- `docker compose` no existe → Docker viejo con `docker-compose` v1: actualizar Docker.
- `sdk env install` no encuentra `21.0.12-tem` → `sdk list java`, elegir el Temurin 21 más nuevo y actualizar `.sdkmanrc` en un PR.
