# 0001 · PostgreSQL como única base de datos, con Flyway

- Estado: **Propuesto** (confirma el dueño) · Fecha: 2026-10-10

## Contexto
El back trae drivers de MySQL y PostgreSQL (`server/pom.xml:72-81`) y configura la base por variables. El proyecto empezó en MySQL (historia de `application.properties`) y producción (Render) usa PostgreSQL. El esquema lo genera Hibernate con `ddl-auto=create-drop` (`application.properties:11`): cada arranque borra los datos, también en producción.

## Decisión
- PostgreSQL 16 es la única base soportada (local vía `docker-compose.yml`, tests vía Testcontainers, producción).
- Se elimina el driver de MySQL.
- El esquema pasa a **Flyway** (`V1__baseline.sql` generado desde el modelo actual); `ddl-auto=validate` en todos los perfiles.
- El seed de datos de ejemplo corre solo con el perfil `dev`/`demo`.

## Alternativas
- Mantener ambas bases: duplica pruebas y dialectos sin beneficio para el portfolio.
- Liquibase: equivalente; Flyway es más simple con SQL plano.
- Seguir con `create-drop`: cómodo para la demo, pero pierde datos y oculta cambios de esquema.

## Consecuencias
- Cambios de modelo requieren una migración nueva (nunca editar una ya aplicada).
- La demo pública necesita perfil `demo` para conservar el seed.
- Tareas: backlog P1 "Flyway + perfiles" y "quitar driver MySQL".
