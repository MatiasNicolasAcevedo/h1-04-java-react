<h1 align="center">💓 Justina.io</h1>

<p align="center">Plataforma web para la gestión médica de pacientes trasplantados y la coordinación entre pacientes, doctores e instituciones.<br>MVP creado por el equipo <b>h1-04-java-react</b> en la hackatón de <a href="https://www.nocountry.tech/">No Country</a>.</p>

<p align="center">
  <img alt="Java 17+" src="https://img.shields.io/badge/Java-17%2B-007396?logo=openjdk&logoColor=white">
  <img alt="Spring Boot 3.3" src="https://img.shields.io/badge/Spring%20Boot-3.3-6DB33F?logo=springboot&logoColor=white">
  <img alt="React 18" src="https://img.shields.io/badge/React-18-61DAFB?logo=react&logoColor=black">
  <img alt="Vite 5" src="https://img.shields.io/badge/Vite-5-646CFF?logo=vite&logoColor=white">
  <img alt="PostgreSQL 16" src="https://img.shields.io/badge/PostgreSQL-16-4169E1?logo=postgresql&logoColor=white">
</p>

<p align="center">
  <a href="https://youtu.be/RtNjyRXNGm8"><img src="https://github.com/user-attachments/assets/95a4cb0c-9a31-4bda-a6d5-7e48764cdcaf" alt="Video de demostración de Justina.io" width="640"></a>
</p>

## Qué problema resuelve

Justina.io (por la [Ley Justina](https://www.argentina.gob.ar/sites/default/files/ley-27447.pdf) de donación de órganos) busca agilizar el seguimiento de pacientes trasplantados: turnos, tratamientos, recetas e historia clínica en un solo lugar, con una vista para cada rol.

**Funcionalidades** (✅ funciona con el back · 🚧 en progreso o con datos de ejemplo):

- ✅ Autenticación con JWT y redirección por rol (administrador, doctor, paciente).
- ✅ API de usuarios, doctores, pacientes, turnos, tratamientos, recetas, medicamentos, laboratorios, financiadores e instituciones ([Swagger](#levantar-el-proyecto-en-local) en local).
- 🚧 Agenda de turnos: la API existe, pero no hay turnos de ejemplo y la agenda del admin usa datos fijos.
- 🚧 Planes de tratamiento del paciente, trasplante cruzado y descarga de historia clínica: pantallas con datos de ejemplo.
- 🚧 Subida de archivos (Cloudinary) y emails (Gmail SMTP): requieren credenciales propias.
- 🧪 Dictado por voz en la consulta médica ([Web Speech API](https://developer.mozilla.org/en-US/docs/Web/API/SpeechRecognition#browser_compatibility)).

Estado detallado y próximos pasos: [docs/STATUS.md](docs/STATUS.md) · [docs/ROADMAP.md](docs/ROADMAP.md).

## Stack

| Parte | Tecnologías |
|---|---|
| Back (`server/`) | Java 17 (corre con 17+; probado con 21), Spring Boot 3.3.1, Spring Security + JWT (jjwt 0.11), Spring Data JPA/Hibernate, PostgreSQL 16, springdoc-openapi 2.2, Lombok, Maven 3.9 (wrapper) |
| Front (`client/`) | React 18.3, Vite 5.3, React Router 6, Tailwind CSS 3.4, Formik, JavaScript |
| Infra | Docker Compose (base de datos local), Render (back), Firebase Hosting (front) |

Arquitectura, modelo de datos y endpoints: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Levantar el proyecto en local

### Prerrequisitos

| Herramienta | Versión | Cómo comprobarla | Cómo instalarla |
|---|---|---|---|
| Git | cualquiera | `git --version` | https://git-scm.com/downloads |
| Java (JDK) | 21 (mínimo 17) | `java -version` | [SDKMAN](https://sdkman.io/): `sdk env install` en la raíz del repo (usa `.sdkmanrc`), o [Temurin](https://adoptium.net/) |
| Node.js | 22 (con npm 10) | `node -v` | [nvm](https://github.com/nvm-sh/nvm): `nvm install` en la raíz del repo (usa `.nvmrc`) |
| Docker + Compose v2 | Docker 24+ | `docker compose version` | [Docker Desktop](https://www.docker.com/products/docker-desktop/) o Docker Engine |
| curl | cualquiera | `curl --version` | viene con macOS, Linux y Windows 10+ |

No hace falta instalar Maven ni PostgreSQL: se usan el wrapper `./mvnw` y un contenedor.

### Inicio rápido

Desde la raíz del repo:

```bash
./scripts/dev.sh
```

**Resultado esperado:** al cabo de ~30 s (más la primera vez, por las descargas) aparece el cuadro `Justina.io running locally` con las URLs. Abrí http://localhost:5173. `Ctrl+C` apaga todo.

> ⚠️ Hoy el front llama a la API de producción, no a la local: el login desde la pantalla no funciona en local. Ver [T-003](docs/tasks/T-003-client-api-base-url-from-env.md).

### Paso a paso

Es lo mismo que hace `./scripts/dev.sh`, explicado. Usá **dos terminales**: una para el back y otra para el front.

**1. Clonar el repositorio.**

```bash
git clone https://github.com/MatiasNicolasAcevedo/h1-04-java-react.git
```

```bash
cd h1-04-java-react
```

Resultado esperado: `ls` muestra `client/`, `server/`, `scripts/`, `docs/` y `docker-compose.yml`.

**2. Comprobar las versiones de Java y Node** (desde la raíz del repo).

```bash
java -version
```

```bash
node -v
```

Resultado esperado: `openjdk version "21...` (o 17+) y `v22.x`. Si no coinciden, usá `sdk env install` y `nvm install` (ver Prerrequisitos).

**3. Crear el archivo de variables del back** (desde la raíz del repo). Los valores de ejemplo sirven tal cual para desarrollo local.

```bash
cp server/.env.example server/.env
```

Resultado esperado: existe `server/.env`. Qué es cada variable: [docs/SETUP.md](docs/SETUP.md#variables-de-entorno).

**4. Levantar la base de datos** (desde la raíz del repo).

```bash
docker compose up -d --wait db
```

Resultado esperado: termina con `Container justina-db Healthy`. Comprobalo con:

```bash
docker compose ps
```

Debe mostrar `justina-db` con estado `Up ... (healthy)`.

**5. Levantar el back** (terminal 1, desde la raíz del repo; queda corriendo).

```bash
cd server
```

```bash
./mvnw spring-boot:run "-Dspring-boot.run.arguments=--spring.config.import=optional:file:.env[.properties]"
```

Resultado esperado: el log termina con `Started ServerApplication in ... seconds`. El argumento hace que el back lea `server/.env` ([T-002](docs/tasks/T-002-server-load-dotenv.md) lo va a hacer automático). Cada arranque recrea la base y carga los datos de ejemplo.

Comprobalo desde otra terminal:

```bash
curl http://localhost:8080/v1/api/render/health
```

Debe responder `Server is awake and running!`. La documentación de la API queda en http://localhost:8080/swagger-ui/index.html.

**6. Iniciar sesión con un usuario de prueba** (terminal 2, desde la raíz del repo). Usuarios de ejemplo: `admin1@admin.com` (admin), `doctor1@doctor.com` (doctor) y `juan@patient.com` (paciente). Las contraseñas de ejemplo están en el código del seed (`server/src/main/java/io/justina/server/data/DataLoader*.java`) y no se copian en la documentación. Este comando las lee de ahí y prueba el login del admin:

```bash
PASS=$(sed -n 's/.*encode("\([^"]*\)").*/\1/p' server/src/main/java/io/justina/server/data/DataLoaderAdmin.java) && curl -s -X POST http://localhost:8080/v1/api/auth/login -H "Content-Type: application/json" -d "{\"email\":\"admin1@admin.com\",\"password\":\"$PASS\"}"
```

Resultado esperado: un JSON con `"message":"Welcome to Justina.io"`, `"role":"ADMIN"` y un `token`.

**7. Levantar el front** (terminal 2, desde la raíz del repo; queda corriendo).

```bash
cd client
```

```bash
npm ci
```

```bash
npm run dev
```

Resultado esperado: `VITE v5... ready` y `Local: http://localhost:5173/`. Abrí esa URL: se ve la landing de Justina.io; en `/login` se ve el formulario.

> ⚠️ Hoy falla el login desde la pantalla en local: el front tiene la URL de la API de producción fija en el código. Ver [T-003](docs/tasks/T-003-client-api-base-url-from-env.md). La API local funciona (paso 6).

**8. Correr los controles de calidad** (desde la raíz del repo).

```bash
./scripts/verify.sh
```

Resultado esperado: un resumen `server: ... client: ...` y `RESULT: ✅ PASS`.

> ⚠️ Hoy falla: el test del back necesita una base de datos ([T-001](docs/tasks/T-001-server-test-infrastructure.md)) y ESLint marca errores ([T-004](docs/tasks/T-004-client-fix-lint-errors.md), [T-005](docs/tasks/T-005-client-prop-types.md)). El build de ambas partes sí pasa.

**9. Apagar todo.** `Ctrl+C` en las terminales del back y del front, y desde la raíz del repo:

```bash
docker compose down
```

Resultado esperado: `Container justina-db Removed`. Para borrar también los datos de la base (volumen):

```bash
docker compose down -v
```

### Windows

- Corré los comandos en **Git Bash** o **WSL** (los scripts `scripts/*.sh` son de bash). Docker Desktop debe estar abierto.
- En PowerShell o CMD el paso 5 es: `.\mvnw.cmd spring-boot:run "-Dspring-boot.run.arguments=--spring.config.import=optional:file:.env[.properties]"` y el paso 3 es `copy server\.env.example server\.env`. ⚠️ No verificado en Windows.
- El paso 6 usa `sed`: en PowerShell copiá la contraseña desde `DataLoaderAdmin.java` (línea con `passwordEncoder.encode`) o usá Swagger UI.

### Problemas frecuentes

| Síntoma | Causa | Solución |
|---|---|---|
| `./mvnw: Permission denied` | El wrapper perdió el permiso de ejecución | `chmod +x server/mvnw` |
| `Cannot load driver class: ${DB_DRIVER_CLASS_NAME}` | El back no leyó `server/.env` | Crear `server/.env` (paso 3) y arrancar con el argumento del paso 5, desde `server/` |
| `Connection to localhost:5432 refused` | La base no está levantada | `docker compose up -d --wait db` |
| `Bind for 0.0.0.0:5432 failed: port is already allocated` | Hay otro PostgreSQL local en el 5432 | Detenerlo (p. ej. `sudo service postgresql stop`) o cambiar el puerto en `docker-compose.yml` (`"5433:5432"`) y en `DB_URL` de `server/.env` |
| `Port 8080 was already in use` | Otra app usa el 8080 | Cerrarla, o agregar `--server.port=8081` al argumento del paso 5 |
| `429 Too Many Requests` al bajar `postgres:16-alpine` | Límite de descargas anónimas de Docker Hub | `docker login`, o esperar y reintentar |
| `release version 17 not supported` | Java menor a 17 | Instalar Java 21 (Prerrequisitos) |
| El login en la pantalla falla o da error de CORS | El front llama a producción | Ver [T-003](docs/tasks/T-003-client-api-base-url-from-env.md) |
| Faltan íconos en la interfaz | Se descargan de `api.iconify.design` en tiempo de ejecución | Requiere conexión a internet |

Más detalle (variables, sin Docker, IDE, debugging): [docs/SETUP.md](docs/SETUP.md).

_Verificado el 2026-10-10 en Linux (Ubuntu 24.04) con Java 21.0.12, Node 22.22.0, Docker 29.8.2 (Compose v5.6)._

## Tests y calidad

- `./scripts/verify.sh` es el control único: build + lint + tests del back y del front (`./scripts/verify.sh server` o `client` para una sola parte).
- Estrategia, herramientas y cómo correr un solo test: [docs/TESTING.md](docs/TESTING.md).

## Cómo se trabaja en el proyecto

El repo está preparado para desarrollo asistido por agentes de IA: [AGENTS.md](AGENTS.md) es el punto de entrada para cualquier agente, y el flujo de ramas, commits y PRs está en [CONTRIBUTING.md](CONTRIBUTING.md). El tablero de tareas vive en [docs/BACKLOG.md](docs/BACKLOG.md).

## Diseño y enlaces

- Demo publicada: https://hackathon-por-justina.web.app/ (el back en Render free tier puede tardar en despertar).
- [Diseño en Figma](https://www.figma.com/design/JqCxyf2Hfotlruh2glaqN6/Hackaton-Justina?node-id=25-19&t=abhMHMih64wc2uEW-1) · [Diagrama entidad-relación (PDF)](https://drive.google.com/file/d/1EWk72gLBysvzqzxzEhsiv4TPakScYo5L/view?usp=sharing) · [Video](https://youtu.be/RtNjyRXNGm8)

<p align="center">
  <img src="https://github.com/user-attachments/assets/d95c666e-19d8-436a-af03-4119b3583ff7" alt="Captura de Justina.io" width="420">
  <img src="https://github.com/user-attachments/assets/51dc5524-62bb-4a3e-bb05-b3a016df7a7f" alt="Captura de Justina.io" width="420">
</p>

## Equipo

| Rol | Persona |
|---|---|
| Team Leader | [Diego Gonzalez](https://www.linkedin.com/in/diego-gonzalez-7937aa16/) |
| QA Tester | [Yosmarli Parica](https://www.linkedin.com/in/yosmarli-parica-1156461a2/) |
| Diseño UX/UI | [Cynthia Olocco](https://www.linkedin.com/in/cynthia-olocco-141081295/) · [Lisandro Argüello](https://www.linkedin.com/in/lisandroarguello/) |
| Frontend | [Facundo Bacigalupo](https://www.linkedin.com/in/facundomarcobacigalupo/) · [Camilo Martinez](https://www.linkedin.com/in/camilomartinez01/) |
| Backend | [Valerie Ramos](https://www.linkedin.com/in/valeriedramosg/) · [Matias Acevedo](https://www.linkedin.com/in/matias-nicolas-acevedo/) |

Gracias a [No Country](https://www.nocountry.tech/) por la simulación laboral.

## Licencia

Todavía sin licencia definida (decisión pendiente, ver [docs/STATUS.md](docs/STATUS.md)). Mantenido por [Matias Acevedo](https://github.com/MatiasNicolasAcevedo).
