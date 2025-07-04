#!/bin/bash

MISSING_FILE="init-db.sh"

echo "=== Finding $MISSING_FILE in the host (ignore the leading /host/ segment) ==="
docker run --rm -v /:/host alpine sh -c "find /host/ -type f -name '$MISSING_FILE' 2>/dev/null"
echo ""

echo "=== Finding $MISSING_FILE in the container ==="
docker compose exec postgres-15 sh -c "find / -type f -name '$MISSING_FILE' 2>/dev/null"
echo ""

echo "===  Docker context inspect ==="
docker context inspect
echo ""

echo "===  Docker Info ==="
docker info
echo ""

for cid in $(docker ps -q); do
    cname=$(docker inspect --format '{{.Name}}' "$cid" | sed 's|^/||')  # strip leading /
    echo "=== Container $cname ==="
    docker container inspect "$cid"
    echo ""
done