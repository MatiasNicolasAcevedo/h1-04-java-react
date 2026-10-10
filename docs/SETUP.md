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

## Agentes
Ejecutores y traspasos: `AGENTS.md` §1. Matriz de revisión: `CONTRIBUTING.md` §4.

### 🤖 Agente gratuito (IntelliJ IDEA, modelo Qwen)
- **Archivo de contexto:** ⚠️ no verificado directamente (las páginas de JetBrains están bloqueadas por el proxy del entorno donde se escribió esto; dato tomado de resultados de búsqueda de la ayuda oficial, 2026-10). El **chat de AI Assistant** aplica *project rules* de `.aiassistant/rules/*.md`; los **agentes** (Junie y los agentes ACP) leen `AGENTS.md` (Junie: *Guidelines path* configurable, por defecto `.junie/guidelines.md`). Por eso:
  - `.aiassistant/rules/agents.md` es un puntero de una línea a `AGENTS.md`. Confirmá en *Settings → Tools → AI Assistant → Rules* que figure con tipo **Always**.
  - Si usás Junie: *Settings → Tools → Junie → Guidelines path* = `AGENTS.md`.
  - En todos los casos, la **frase de arranque** cubre la duda: «Leé `AGENTS.md` y seguí `docs/agents/implementer.md`».
- **Chat nuevo** (una tarea = un chat; también es la forma de "compactar"): en la ventana de AI Chat, botón **+ / New Chat**. No reutilices un chat de otra tarea.
- **Modo:** elegí el modo **agente** (el que edita archivos y corre comandos), no el de solo chat. Los nombres exactos del selector cambian entre versiones.
- **Terminal:** el agente pide permiso para cada comando; aprobá los de `AGENTS.md` §3 y los `git` de lectura. No le des aprobación automática para todo (*brave mode* o similar): nunca debe correr `git push` a `main`, `--force` ni `docker compose down -v`.
- **Contexto efectivo supuesto:** ~64K tokens. Las tareas 🤖 están dimensionadas para usar < 40 %.
- **Git y PR:** no tiene `gh` ni MCP de GitHub; usa `git` en la terminal del IDE con tus credenciales (las del IDE o el *credential helper*). Empuja su rama con `git push -u origin <rama>` y te deja el **link de comparación** `https://github.com/MatiasNicolasAcevedo/h1-04-java-react/compare/main...<rama>?expand=1` con título y cuerpo listos: **vos abrís el PR** (en draft) y pegás sus comentarios de revisión. Para ver ramas usa `git ls-remote --heads origin`; para leer un diff, `git diff main...origin/<rama>`.

### 🧠 Modelo de frontera (Claude Code)
- Lee `CLAUDE.md` → `@AGENTS.md`. `.claude/settings.json` permite sin preguntar los comandos seguros (verify, tests, lint, `git status/diff/log/show`, `gh pr view/list/diff/checks`) y niega push forzado, push a `main` y leer `.env`.
- **GitHub:** `gh` CLI autenticado (`gh auth login`) o MCP de GitHub. Con una sola cuenta no se puede aprobar el propio PR: la revisión es un comentario con veredicto. Opcional: cuenta bot o GitHub App solo para revisar.
- Compactar: `/compact` con la instrucción de `AGENTS.md` §5.

## Problemas del entorno
Ver la tabla del [README](../README.md#problemas-frecuentes). Además:
- `docker compose` no existe → Docker viejo con `docker-compose` v1: actualizar Docker.
- `sdk env install` no encuentra `21.0.12-tem` → `sdk list java`, elegir el Temurin 21 más nuevo y actualizar `.sdkmanrc` en un PR.
