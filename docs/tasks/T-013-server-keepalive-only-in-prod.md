# T-013 · Run the Render keep-alive ping only when enabled by property
- Estado: Bloqueada (espera T-001) · Prioridad: P0 · Esfuerzo: S · Agente: 🤖 ligero
- Fase: P0 Estabilizar
- Rama: `fix/T-013-keepalive-only-in-prod` · Depende de: T-001 · Spec/ADR: —
- Revisa: ligero en sesión nueva

## Por qué
`util/ServerWakeUpScheduler.java` hace `GET https://h1-04-java-react-qrtk.onrender.com/v1/api/render/health` cada 14 min en **todos** los entornos (local, tests, CI), con `System.out/err` (auditoría §4.3).

## Objetivo
El ping solo corre si `app.keep-alive.enabled=true` (variable `KEEP_ALIVE_ENABLED`, por defecto `false`); la URL sale de `app.keep-alive.url`.

## Alcance
- Incluye: `@ConditionalOnProperty(name = "app.keep-alive.enabled", havingValue = "true")` en la clase; propiedades `app.keep-alive.enabled=${KEEP_ALIVE_ENABLED:false}` y `app.keep-alive.url=${KEEP_ALIVE_URL:https://h1-04-java-react-qrtk.onrender.com}` en `application.properties`; logger SLF4J en vez de `System.out/err`; fila en `docs/SETUP.md` (variables).
- **No incluye:** otras propiedades, `Dockerfile`, el endpoint de health.

## Leer antes
- `server/src/main/java/io/justina/server/util/ServerWakeUpScheduler.java` (27 líneas)
- `server/src/main/resources/application.properties` · test de referencia de T-001

## Archivos previstos
- modificar: `ServerWakeUpScheduler.java`, `application.properties`, `docs/SETUP.md`
- crear: `server/src/test/java/io/justina/server/util/ServerWakeUpSchedulerIT.java`

## Tests
- IT: por defecto el contexto **no** tiene el bean `ServerWakeUpScheduler`; con `@TestPropertySource(properties = "app.keep-alive.enabled=true")` **sí** lo tiene (sin esperar al schedule).

## Pasos sugeridos
1. Escribir el IT (falla el caso "por defecto no existe").
2. Anotar la clase, inyectar la URL con `@Value`, cambiar a logger.
3. Agregar las propiedades y la fila de SETUP. Mencionar en el PR: **el dueño debe definir `KEEP_ALIVE_ENABLED=true` en Render**.

## Criterios de aceptación
- [ ] `ServerWakeUpSchedulerIT` (2 casos) pasa; `./scripts/verify.sh server` verde; cobertura no baja.
- [ ] Arrancando en local, `.dev-logs/server.log` no contiene `Health Check Result` ni `Error al realizar el Health Check`.
- [ ] `grep -n "System\.\(out\|err\)" server/src/main/java/io/justina/server/util/ServerWakeUpScheduler.java` sin resultados.
- [ ] El PR indica la variable que hay que configurar en Render.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
