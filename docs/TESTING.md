# Estrategia de testing

Estado hoy: back 1 test de contexto (falla sin DB), front 0, E2E 0. Esta guía define cómo se construye la red; la infraestructura llega con T-001 (back), T-006 (front) y T-010 (E2E).

## 1. Pirámide y herramientas

**Back** (`server/`, JUnit 5 vía `spring-boot-starter-test`, AssertJ, Mockito, `spring-security-test`):
- **Unitarios** de servicios (`services/impl/*`): JUnit + AssertJ + Mockito para repositorios. Mockito con mesura: no mockear lo que se puede construir.
- **`@WebMvcTest`** por controller: validación (400), códigos HTTP, formato de error, seguridad (401/403) con `spring-security-test` (`@WithMockUser`, `jwt()`).
- **`@DataJpaTest`** solo para queries propias de repositorios.
- **Integración** `@SpringBootTest` + **Testcontainers PostgreSQL** (`@ServiceConnection`): misma base que producción, sin H2 (ver [ADR 0002](adr/0002-testcontainers-postgresql-for-tests.md)).
- **Cobertura:** JaCoCo (`./mvnw verify` genera `target/site/jacoco/` y aplica el umbral).

**Front** (`client/`):
- **Vitest** + **React Testing Library** + `@testing-library/user-event` + `jsdom`: probar comportamiento visible, consultar por rol/label/texto, nunca por clases CSS o estado interno.
- **MSW** para simular la API (handlers por servicio, derivados del OpenAPI `/v3/api-docs`).
- **Cobertura:** proveedor v8 de Vitest.

**E2E:** **Playwright**, pocos smoke tests de flujos críticos, en viewport desktop (1280) y mobile (375) — sirve también de control de responsive —, con screenshots y trazas en fallos. Corre con `scripts/e2e.sh` (back + front + DB).

## 2. Qué testear y qué no
- Sí: reglas de negocio de servicios, validaciones de DTOs, permisos por rol, contratos de la API (status + forma del JSON), estados de UI (cargando, error, vacío, datos), redirecciones por rol.
- No: getters/setters, Lombok, mapeos triviales, código generado, el framework (que Spring inyecta o que React renderiza).

## 3. Convenciones
- **Ubicación:** back en `server/src/test/java/io/justina/server/<mismo paquete>`; front junto al componente: `Componente.test.jsx`.
- **Nombres:** `XServiceTest`, `XControllerTest`, `XRepositoryTest`, `XIT` (integración con Testcontainers); front `x.test.jsx`; E2E `e2e/<flujo>.spec.js`.
- **Estructura:** Arrange / Act / Assert separados por una línea en blanco. Un comportamiento por test.
- **Nombre del test = comportamiento:** `createDoctor_returns400_whenEmailIsInvalid`, `it('redirects a patient to /patient after login')`.
- **Datos de prueba:** builders/fábricas (`TestData.doctor().withEmail(...)`, `src/test/fixtures/`), nunca depender del seed de `data/`.
- **Archivos de referencia** (copiá su estilo; se crean en las tareas de infraestructura):
  - integración back: `server/src/test/java/io/justina/server/ServerApplicationTests.java` + el primer `*IT` de T-001
  - controller: `LoginControllerTest` (T-015)
  - componente front: el primer test de T-006
- **Un solo test:** back `cd server && ./mvnw -q test -Dtest='NombreTest#metodo'` · front `cd client && npx vitest run src/ruta/archivo.test.jsx -t "nombre"`.

## 4. Reglas para todas las tareas
- Todo cambio de comportamiento viene con sus tests en el mismo PR.
- **Bugfix = primero un test que reproduce el bug y falla**, después el fix (mencionarlo en el PR).
- Antes de refactorizar o migrar código sin tests: tests de caracterización que fijen el comportamiento actual (aunque sea raro), y recién después el cambio.
- Prohibido borrar, deshabilitar (`@Disabled`, `.skip`, `.only`) o debilitar tests para que pase el build. Si un test está mal, se corrige y se justifica en el PR.
- Tests deterministas: sin depender del orden, de la hora (inyectar `Clock`), de la red (MSW / mocks) ni de datos compartidos entre tests. Un test inestable es un bug con su tarea.

## 5. Cobertura como trinquete
- T-001 y T-006 miden la línea de base y fijan el umbral (JaCoCo `check`, Vitest `coverage.thresholds`) en ese valor redondeado hacia abajo.
- **El umbral nunca baja.** Cada auditoría lo sube si la cobertura real creció.
- Meta orientativa: ≥ 70–80 % en `services/` y lógica del front; los flujos críticos siempre cubiertos de punta a punta. La cobertura es un piso, no el objetivo.

## 6. Flujos críticos (deben tener al menos un test que falle si se rompen)
1. Login por rol y redirección · 2. Acceso denegado sin token / rol incorrecto · 3. Alta de doctor y paciente (admin) · 4. Pedir turno (paciente) y ver turnos (doctor) · 5. Ficha e historia clínica del paciente · 6. Asignar tratamiento y receta · 7. Arranque con seed.
Estado actual de cada uno: [auditoría §4.7](audits/2026-10-10-initial.md#47-testing-dimensión-central).

## 7. Roadmap de testing (antes de cualquier migración de versión)
1. 🧠 T-001 — Back: JaCoCo con umbral de base, Testcontainers, `contextLoads` verde, primer `*IT`.
2. 🧠 T-006 — Front: Vitest + RTL + MSW, `npm test`, primer test de ejemplo.
3. 🧠 T-010 — E2E: Playwright + `scripts/e2e.sh` + job de CI, smoke del flujo 1.
4. 🤖 Caracterización: T-015 (auth) y una tarea por controller/flujo crítico (backlog).

## 8. Opcional (auditorías)
Mutation testing puntual con PIT (back) o Stryker (front) sobre `services/` críticos, para medir si los tests detectan cambios de lógica.
