#!/usr/bin/env bash
# dev.sh — starts the full local environment: PostgreSQL (Docker), server (8080) and client (5173).
# Does exactly what the README "Paso a paso" describes. Stop everything with Ctrl+C.
# Usage: ./scripts/dev.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$ROOT/.dev-logs"
mkdir -p "$LOG_DIR"

need() { command -v "$1" >/dev/null 2>&1 || { echo "❌ Missing '$1'. See README → Prerrequisitos."; exit 1; }; }
need docker; need java; need node; need npm; need curl

# wait_for <url> <seconds> <name> <log>
wait_for() {
  local url="$1" timeout="$2" name="$3" log="$4"
  for _ in $(seq 1 "$timeout"); do
    if curl -fsS -o /dev/null "$url" 2>/dev/null; then echo "✅ $name ready"; return 0; fi
    sleep 1
  done
  echo "❌ $name did not start in ${timeout}s. Last lines of $log:"; tail -n 30 "$log"; exit 1
}

PIDS=()
# Kill a process and all its descendants (mvnw forks the app JVM, npm forks vite).
kill_tree() {
  local child
  for child in $(pgrep -P "$1" 2>/dev/null); do kill_tree "$child"; done
  kill "$1" 2>/dev/null || true
}
cleanup() {
  trap - EXIT INT TERM
  echo; echo "Stopping server and client..."
  for pid in ${PIDS[@]+"${PIDS[@]}"}; do kill_tree "$pid"; done
  (cd "$ROOT" && docker compose stop db >/dev/null 2>&1) || true
  echo "Stopped. Data is kept in the Docker volume; remove it with: docker compose down -v"
}
trap cleanup EXIT INT TERM

# 1. Environment file (never overwrite an existing one)
if [ ! -f "$ROOT/server/.env" ]; then
  cp "$ROOT/server/.env.example" "$ROOT/server/.env"
  echo "Created server/.env from server/.env.example"
fi
if [ -f "$ROOT/client/.env.example" ] && [ ! -f "$ROOT/client/.env" ]; then
  cp "$ROOT/client/.env.example" "$ROOT/client/.env"
  echo "Created client/.env from client/.env.example"
fi

# 2. Database
echo "Starting PostgreSQL..."
(cd "$ROOT" && docker compose up -d --wait db)
echo "✅ PostgreSQL ready on localhost:5432"

# 3. Server (loads server/.env; see docs/SETUP.md → Variables)
echo "Starting server (log: .dev-logs/server.log)..."
(cd "$ROOT/server" && exec ./mvnw -q -B spring-boot:run \
  "-Dspring-boot.run.arguments=--spring.config.import=optional:file:.env[.properties]") \
  >"$LOG_DIR/server.log" 2>&1 &
PIDS+=($!)
wait_for "http://localhost:8080/v1/api/render/health" 180 "Server" "$LOG_DIR/server.log"

# 4. Client
cd "$ROOT/client"
if [ ! -d node_modules ]; then echo "Installing client dependencies..."; npm ci --no-audit --no-fund >"$LOG_DIR/npm-ci.log" 2>&1; fi
echo "Starting client (log: .dev-logs/client.log)..."
npm run dev -- --port 5173 --strictPort >"$LOG_DIR/client.log" 2>&1 &
PIDS+=($!)
wait_for "http://localhost:5173" 60 "Client" "$LOG_DIR/client.log"

cat <<'EOF'

──────────────────────────────────────────────
 Justina.io running locally
   App (client):  http://localhost:5173
   API health:    http://localhost:8080/v1/api/render/health
   Swagger UI:    http://localhost:8080/swagger-ui/index.html
   Demo users:    see README → "Iniciar sesión"
 Press Ctrl+C to stop.
──────────────────────────────────────────────
EOF
wait
