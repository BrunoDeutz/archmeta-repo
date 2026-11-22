#!/bin/sh
# ArchMeta launcher (Linux/macOS).
# Usage: ./archmeta.sh [repo-folder]
set -eu

VERSION="${ARCHMETA_VERSION:-2.0.0}"
IMAGE="archmeta/archmeta:${VERSION}"
PORT="${ARCHMETA_HOST_PORT:-7777}"

RUNTIME=""
for candidate in docker podman nerdctl; do
  if command -v "$candidate" >/dev/null 2>&1; then RUNTIME="$candidate"; break; fi
done

if [ -z "$RUNTIME" ]; then
  echo "No container runtime found. Install one of these (all free):" >&2
  echo "  Podman Desktop   https://podman-desktop.io" >&2
  echo "  Rancher Desktop  https://rancherdesktop.io" >&2
  echo "  Docker Desktop   https://docker.com  (paid above ~250 employees)" >&2
  exit 1
fi

REPO="$(cd "${1:-$PWD}" && pwd)"

if ! "$RUNTIME" image inspect "$IMAGE" >/dev/null 2>&1; then
  TAR="$(dirname "$0")/archmeta-${VERSION}.tar.gz"
  if [ -f "$TAR" ]; then
    echo "Loading $TAR ..."
    gunzip -c "$TAR" | "$RUNTIME" load
  else
    "$RUNTIME" pull "$IMAGE"
  fi
fi

# Mounting a missing .gitconfig is an error on some runtimes, so it is
# conditional: a stage-1 architect may not have one at all.
GITCONFIG_MOUNT=""
if [ -f "$HOME/.gitconfig" ]; then
  GITCONFIG_MOUNT="-v $HOME/.gitconfig:/home/archmeta/.gitconfig:ro"
fi

echo "ArchMeta starting on http://127.0.0.1:${PORT}  (repo: $REPO)"
echo "Press Ctrl-C to stop."

# -it only when there really is a terminal. Double-clicking the launcher gives
# one; running it from a script or CI does not, and podman then warns
# "The input device is not a TTY" on every start.
TTY_FLAGS=""
[ -t 0 ] && TTY_FLAGS="-it"

# shellcheck disable=SC2086
"$RUNTIME" run --rm $TTY_FLAGS \
  --name archmeta \
  --user "$(id -u):$(id -g)" \
  -p "127.0.0.1:${PORT}:7777" \
  -v "$REPO:/repo" \
  $GITCONFIG_MOUNT \
  "$IMAGE" &

RUNPID=$!

# Wait for health, then open the browser.
i=0
while [ "$i" -lt 60 ]; do
  if curl -sf "http://127.0.0.1:${PORT}/health" >/dev/null 2>&1; then
    if command -v open >/dev/null 2>&1; then open "http://127.0.0.1:${PORT}"
    elif command -v xdg-open >/dev/null 2>&1; then xdg-open "http://127.0.0.1:${PORT}"
    fi
    break
  fi
  i=$((i+1)); sleep 1
done

wait "$RUNPID"
