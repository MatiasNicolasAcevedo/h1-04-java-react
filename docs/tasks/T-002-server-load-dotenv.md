# T-002 · Load server/.env automatically on startup
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Agente: 🤖 ligero
- Fase: P0 Estabilizar
- Rama: `chore/T-002-server-load-dotenv` · Depende de: — · Spec/ADR: —
- Revisa: ligero en sesión nueva

## Por qué
`application.properties:1` importa `optional:env.properties` del **classpath**, así que `server/.env` no se lee solo y hay que arrancar con un argumento largo (`-Dspring-boot.run.arguments=--spring.config.import=...`), auditoría §3 y §4.11.

## Objetivo
Desde `server/`, `./mvnw spring-boot:run` (sin argumentos) arranca leyendo `server/.env`.

## Alcance
- Incluye: cambiar la línea 1 de `application.properties`; quitar el argumento largo de `scripts/dev.sh` y de la documentación.
- **No incluye:** renombrar variables, cambiar otros valores de `application.properties`, tocar `Dockerfile` ni el deploy.

## Leer antes
- `server/src/main/resources/application.properties` (L1)
- `scripts/dev.sh` (paso "3. Server", ~L55-60)
- `README.md` § Paso a paso, paso 5 y § Windows

## Archivos previstos
- modificar: `server/src/main/resources/application.properties`, `scripts/dev.sh`, `README.md`, `server/README.md`, `server/AGENTS.md`, `AGENTS.md` (§10 Gotchas), `docs/SETUP.md` (§ Cómo se cargan, § IDE, § Debugging)

## Tests
- No hay infraestructura de tests de back todavía (T-001); la verificación es por comando (criterios). No agregar tests.

## Pasos sugeridos
1. Reemplazar la línea 1 por: `spring.config.import=optional:env.properties,optional:file:.env[.properties]` (conserva el import anterior; `file:.env` es relativo a la carpeta desde donde se arranca, `server/`).
2. En `scripts/dev.sh`, dejar solo `./mvnw -q -B spring-boot:run`.
3. En los docs listados, reemplazar el comando largo por `./mvnw spring-boot:run` (Windows: `.\mvnw.cmd spring-boot:run`) y borrar las notas que remiten a T-002.

## Criterios de aceptación
- [ ] Con la DB levantada y `server/.env` creado: `cd server && ./mvnw spring-boot:run` arranca y `curl http://localhost:8080/v1/api/render/health` responde `Server is awake and running!`.
- [ ] Sin `server/.env` el back sigue arrancando si las variables están exportadas en la shell (`set -a; . ./.env.example; set +a` y luego `./mvnw spring-boot:run`).
- [ ] `./scripts/dev.sh` levanta todo y `Ctrl+C` apaga todo.
- [ ] `grep -rn "spring-boot.run.arguments" README.md server AGENTS.md docs/SETUP.md scripts` no devuelve resultados (salvo el ejemplo de debugging si se conserva con otro propósito).
- [ ] `./scripts/verify.sh` sin regresiones respecto de `main`.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: — · Pendientes → nuevas tareas: …
