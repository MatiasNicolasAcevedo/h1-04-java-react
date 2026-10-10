# 0003 · Camino de actualización: Spring Boot 3.3 → 3.5 → 4.x

- Estado: **Propuesto** · Fecha: 2026-10-10

## Contexto
El back usa Spring Boot 3.3.1 (`server/pom.xml:7`), sin soporte OSS. Según la búsqueda del 2026-10-10 (a confirmar en spring.io): 3.5 terminó soporte OSS el 2026-06-30, 4.0 termina el 2026-12-31 y 4.1.x es la línea vigente. Boot 4 trae Jakarta EE 11, Hibernate 7, Jackson 3, Spring Security 7 y JUnit 6; baseline Java 17.

## Decisión
1. Primero la red de tests de P0 (T-001, T-015 y caracterización de flujos críticos).
2. **3.3 → 3.5.x** (cambios menores; actualizar springdoc a 2.8.x y jjwt a 0.12+) en una tarea.
3. **3.5 → 4.x** en otra tarea, evaluando **OpenRewrite** (`rewrite-spring`, receta de migración a Boot 4) para lo mecánico, y revisión manual de Security y Jackson.
4. Java 21 como runtime y target (Java 25 cuando el ecosistema lo permita).

## Alternativas
- Saltar directo a 4.x: cambio grande sin pasos intermedios verificables.
- Quedarse en 3.x: sin parches de seguridad OSS.

## Consecuencias
- Cada salto es un PR 🧠 con `verify.sh` y E2E en verde antes y después.
- Tareas: backlog P1.
