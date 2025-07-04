#!/bin/bash

# Check if a file name was provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    echo "Example: $0 init-db.sh"
    exit 1
fi

MISSING_FILE="$1"

echo "=== Finding $MISSING_FILE in the host (ignore the leading /host/ segment) ==="
docker run --rm -v /:/host alpine sh -c "find /host/ -type f -name '$MISSING_FILE' 2>/dev/null"
echo ""

for cid in $(docker ps -q); do
    cname=$(docker inspect --format '{{.Name}}' "$cid" | sed 's|^/||')  # strip leading /
    echo "================================================"
    echo "=== Container $cname: Finding $MISSING_FILE ====="
    docker exec $cname sh -c "find / -type f -name '$MISSING_FILE' 2>/dev/null"
    echo ""
    echo "=== Container $cname: Inspect  ================="
    docker container inspect "$cid"
    echo "================================================"
done

echo "================================================"
echo "======  Docker Context Inspect ================="
docker context inspect
echo ""

echo "================================================"
echo "==============  Docker Info ===================="
docker info
echo ""
