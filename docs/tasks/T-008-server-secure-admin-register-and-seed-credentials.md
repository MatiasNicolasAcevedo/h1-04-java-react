# T-008 · Restrict admin registration to admins and move seed passwords to env
- Estado: Bloqueada (espera T-001) · Prioridad: P0 · Esfuerzo: M · Agente: 🧠 frontera
- Fase: P0 Estabilizar
- Rama: `fix/T-008-secure-admin-register` · Depende de: T-001 (para los tests) · Spec/ADR: —
- Revisa: ligero (segunda mirada) + **dueño** (seguridad)

## Por qué
🔴 `POST /v1/api/auth/admin-register` es público (`config/security/SecurityConfig.java:41` permite `/v1/api/auth/*`) y crea usuarios ADMIN (`services/impl/RegisterServiceImpl.java:69-83`): cualquiera se crea un admin. 🔴 Las contraseñas de los usuarios seed están en el código (`data/DataLoaderAdmin.java:72`, `DataLoaderDoctor.java:108`, `DataLoaderPatient.java:94`) y valen en la demo pública; los botones de demo del login las autocompletan (`client/src/Components/Login/Login.jsx:81,85,89`). Además `User.getAuthorities()` devuelve una lista vacía (`entities/User.java:67-69`), así que hoy no se puede autorizar por rol.

## Objetivo
Solo un ADMIN autenticado puede registrar admins; las contraseñas seed salen de una variable de entorno y se **rotan** en el deploy.

## Alcance
- Incluye: `getAuthorities()` → `ROLE_<nombre del rol>`; `SecurityConfig`: público solo `/v1/api/auth/login` (+ health y Swagger), `admin-register` con `hasRole("ADMIN")`; variable `SEED_DEFAULT_PASSWORD` (en `server/.env.example` con un valor local nuevo, y en `application-test.properties`); los 3 `DataLoader*` la usan; README paso 6 y SETUP actualizados (leer la contraseña de `server/.env`).
- Incluye también: los botones de demo de `Login.jsx` leen la contraseña de `import.meta.env.VITE_DEMO_PASSWORD` (en `client/.env.example`, mismo valor local) o se quitan, **según decida el dueño** (STATUS → Decisiones pendientes). Si la decisión no está, dejarlos leyendo la variable.
- **No incluye:** la matriz de permisos del resto de endpoints (T-009), cambiar el login, JWT o CORS.

## Leer antes
- `server/src/main/java/io/justina/server/config/security/SecurityConfig.java` (todo, 47 líneas)
- `server/src/main/java/io/justina/server/entities/User.java` (L60-90)
- `server/src/main/java/io/justina/server/services/impl/RegisterServiceImpl.java` (L55-95)
- `DataLoaderAdmin.java` (L65-80) · test de referencia de T-001 (`HealthCheckIT`)

## Archivos previstos
- modificar: `client/src/Components/Login/Login.jsx` (L78-92), `client/.env.example`, `SecurityConfig.java`, `User.java`, `DataLoaderAdmin.java`, `DataLoaderDoctor.java`, `DataLoaderPatient.java`, `server/.env.example`, `src/test/resources/application-test.properties`, `README.md` (paso 6), `docs/SETUP.md` (variables y datos de ejemplo)
- crear: `server/src/test/java/io/justina/server/auth/AdminRegisterIT.java`

## Tests
- `AdminRegisterIT`: sin token → 401/403; con token de PATIENT o DOCTOR → 403; con token de ADMIN → 200 y el usuario existe; login seed con `SEED_DEFAULT_PASSWORD` → 200.
- Bugfix: escribir primero el caso "sin token → no 200" y verlo fallar.

## Pasos sugeridos
1. Test que reproduce el registro anónimo (falla).
2. `getAuthorities()` con el rol; `SecurityConfig` con `requestMatchers(POST, "/v1/api/auth/admin-register").hasRole("ADMIN")` antes de los públicos.
3. `@Value("${SEED_DEFAULT_PASSWORD}")` en los loaders.
4. README paso 6: `PASS=$(sed -n 's/^SEED_DEFAULT_PASSWORD=//p' server/.env)`; SETUP: nueva variable.
5. **Para el dueño (en el PR):** definir `SEED_DEFAULT_PASSWORD` con un valor nuevo en Render antes de deployar; los valores viejos siguen en el historial de git y quedan inválidos tras el deploy.

## Criterios de aceptación
- [ ] `curl -s -o /dev/null -w '%{http_code}' -X POST localhost:8080/v1/api/auth/admin-register -H 'Content-Type: application/json' -d '{}'` → `401` o `403` (no `200`/`400`).
- [ ] `AdminRegisterIT` cubre los 4 casos y pasa; `./scripts/verify.sh server` en verde, cobertura no baja.
- [ ] `grep -rn 'encode("' server/src/main/java/io/justina/server/data` sin resultados y `grep -n 'setPassword("' client/src/Components/Login/Login.jsx` sin resultados.
- [ ] README paso 6 probado con el nuevo comando.
- [ ] El PR lista la acción de rotación para el dueño.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
