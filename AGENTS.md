# AGENTS.md

Guía estable para cualquier agente (o persona) que trabaje en este repo. Imperativa y corta. Si algo acá deja de ser cierto, corregilo en el mismo PR.

## 1. Qué es
Justina.io: MVP de hackatón para gestión médica de pacientes trasplantados (pacientes, doctores, turnos, tratamientos, recetas). Monorepo:

```
server/   API REST Spring Boot (puerto 8080)        → server/AGENTS.md
client/   SPA React + Vite (puerto 5173)             → client/AGENTS.md
scripts/  verify.sh (gate) · dev.sh (entorno local)
docs/     estado, tablero, tareas, specs, ADRs, auditorías, protocolos de agentes
docker-compose.yml   solo PostgreSQL para desarrollo
```

## 2. Stack (versiones reales)
- Back: Java 17 (target; se corre con 21), Spring Boot 3.3.1, Spring Security + JWT (jjwt 0.11.5), JPA/Hibernate, PostgreSQL 16, springdoc 2.2, Lombok, Maven wrapper (3.9.7).
- Front: React 18.3, Vite 5.3, React Router 6.26, Tailwind 3.4, Formik, JavaScript (sin TS), ESLint 8.
- Toolchain fijado: `.sdkmanrc` (Java 21), `.nvmrc` (Node 22).

## 3. Comandos verificados
| Para | Comando (desde la raíz) |
|---|---|
| Setup completo | README → "Paso a paso" (no se duplica acá) |
| Todo el entorno local | `./scripts/dev.sh` |
| **Gate (antes de cada PR)** | `./scripts/verify.sh` (o `server` / `client`) |
| Un test del back | `cd server && ./mvnw -q test -Dtest='NombreTest#metodo'` |
| Un test del front | `cd client && npx vitest run src/ruta/archivo.test.jsx` (existe desde T-006) |
| Lint del front | `cd client && npm run lint` |
| Base de datos | `docker compose up -d --wait db` |
| E2E | `./scripts/e2e.sh` (existe desde T-010) |

Hoy `verify.sh` falla (T-001, T-004, T-005): mirá `docs/STATUS.md` → Salud para saber qué es esperable.

## 4. Protocolo de sesión
1. Al empezar: leé `docs/STATUS.md` y `docs/BACKLOG.md`, y listá los PR abiertos (`gh pr list`).
2. Una sola tarea por sesión, en su rama `<tipo>/T-NNN-slug`, con PR en draft desde el primer commit.
3. Los tests van en el mismo PR que el cambio.
4. Al terminar: `./scripts/verify.sh` (sin regresiones), tarea + tablero + `STATUS.md` actualizados, PR listo para revisión, y sugerí abrir una sesión nueva.
5. Protocolos completos: implementar → `docs/agents/implementer.md` · revisar → `docs/agents/reviewer.md` · auditar → `docs/agents/auditor.md`.

## 5. Gestión de contexto
- **Una tarea = una sesión.** Al cerrar una tarea, revisión o auditoría, no sigas con otra: sugerí sesión nueva (`/clear` o conversación nueva). El estado ya está en `STATUS.md` y `BACKLOG.md`.
- **Sugerí compactar** (`/compact` en Claude Code; `/compress` en Qwen Code) solo a mitad de un trabajo largo y si: cerraste una sub-etapa (p. ej. diagnóstico → implementación); acumulaste logs/diffs/archivos que ya no sirven; el uso de contexto supera ~60 % (frontera) o ~50 % (ligero); o ves degradación (releer archivos, olvidar decisiones, repetir intentos).
- **Antes de sugerirlo, persistí:** "Notas de implementación" de la tarea (hecho / pendiente / próximo paso), commit y push.
- **Cómo:** detenete y dale al usuario el texto listo: `/compact Conservar: tarea T-NNN, rama y PR, decisiones, archivos modificados, estado de verify y próximo paso. Descartar: logs y contenido de archivos ya procesados.` y «después escribime "seguí con T-NNN"».
- **No compactes** justo antes de terminar ni entre tareas.
- **Higiene:** salida acotada (`-q`, `| tail -n 60`); grep/glob antes de abrir; leé rangos de líneas; no abras lockfiles, `target/`, `node_modules/`, `dist/`, `client/src/Assets/` ni `docs/archive/`; no pegues archivos enteros en las respuestas; respuestas finales cortas.

## 6. Mapa de documentación
| Archivo | Qué contiene | Cuándo leerlo |
|---|---|---|
| `docs/STATUS.md` | Dónde estamos, salud, próximo paso | Siempre, al empezar |
| `docs/BACKLOG.md` | Tablero de tareas | Siempre, al empezar |
| `docs/tasks/T-NNN-*.md` | Spec de la tarea | Al tomarla |
| `docs/TESTING.md` | Estrategia y convenciones de tests | Al escribir tests |
| `CONTRIBUTING.md` | Ramas, commits, PR, revisión | Al abrir PR o revisar |
| `docs/ARCHITECTURE.md` | Componentes, modelo, endpoints | Si la tarea toca estructura |
| `docs/SETUP.md` | Variables, IDE, problemas de entorno | Si el entorno falla |
| `docs/ROADMAP.md` | Fases e hitos | Auditorías / planificación |
| `docs/adr/` | Decisiones de arquitectura | Si la tarea lo enlaza |
| `docs/specs/` | Specs de features multi-tarea | Si la tarea lo enlaza |
| `docs/audits/` | Auditorías fechadas | Solo auditorías o si la tarea lo enlaza |
| `docs/archive/` | Histórico | **No leer** salvo que la tarea lo indique |

## 7. Convenciones actuales (las que existen, no las ideales)
- **Back** (paquete `io.justina.server`): controller → service (interfaz + `impl/`) → repository (Spring Data). DTOs en `dtos/request` y `dtos/response`, nunca entidades en la respuesta. Validación con `@Valid` + anotaciones en el DTO. Respuestas como `Map<String,Object>` con `message` y el dato. Excepciones propias en `exceptions/`. Inyección `@Autowired` por campo (código nuevo: preferí constructor). Rutas `v1/api/<recurso>/<verbo>` (p. ej. `/doctors/getAllDoctors`).
  - Referencias: controller `server/src/main/java/io/justina/server/controllers/DoctorController.java` · servicio `services/impl/DoctorServiceImpl.java` · DTO `dtos/request/DoctorRequestDTO.java` · repo `repositories/DoctorRepository.java`.
- **Front:** componentes `.jsx` por rol en `client/src/Components/<Rol>/<Pantalla>/`, CSS en archivo hermano en minúsculas o Tailwind; llamadas HTTP solo en `client/src/services/*.js` (funciones `async` que reciben `token`); sesión en `DoctorContext` (`client/src/context/DoctorContext.jsx`); rutas en `client/src/Router/Routers.jsx` con `PrivateRoute role=...`.
  - Referencias: servicio `client/src/services/doctorServices.js` · pantalla `client/src/Components/Doctor/PatientList/PatientList.jsx`.
- **Tests:** todavía no hay ejemplos; se crean en T-001 (back) y T-006 (front). Ver `docs/TESTING.md`.
- Textos de UI en español; código e identificadores en inglés.

## 8. Git (resumen; detalle en `CONTRIBUTING.md`)
- GitHub Flow: rama corta desde `main` actualizado, `<tipo>/T-NNN-slug`; nunca commitear a `main`.
- Conventional Commits `tipo(alcance): descripción` con footer `Refs: T-NNN`.
- Un PR por tarea, título = Conventional Commit (se valida en CI), squash merge.
- Revisión siempre en otra sesión con `docs/agents/reviewer.md`; mergea el dueño.

## 9. Límites (no tocar sin una tarea que lo pida)
- Versiones mayores de dependencias, Java, Node, Spring Boot, React.
- Seguridad/autenticación (`server/.../config/`), CORS, JWT.
- Modelo de datos, entidades y seed (`server/.../entities/`, `data/`).
- Deploy (`server/Dockerfile`, `client/firebase.json`) y CI (`.github/workflows/`).
- Secretos: nunca commitear `.env` ni credenciales; no copiar contraseñas del seed en docs.
- Tests: nunca borrar, saltear, deshabilitar ni debilitar; nunca bajar umbrales de cobertura.
- Nunca commitear a `main`, forzar push ni mergear sin revisión aprobada.

## 10. Gotchas del entorno
- El back **no** lee `server/.env` solo: arrancá con el argumento de README paso 5 o `./scripts/dev.sh` (hasta T-002).
- `ddl-auto=create-drop`: cada arranque del back borra la base y recarga el seed.
- El front tiene la URL de producción fija en `client/src/services/*.js` (hasta T-003).
- `ServerWakeUpScheduler` hace ping a Render cada 14 min, también en local (hasta T-013).
- Si `./mvnw` da *Permission denied*: `chmod +x server/mvnw`.
- Docker Hub puede devolver 429 en entornos compartidos: reintentar o `docker login`.
