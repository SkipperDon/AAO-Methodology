#!/bin/bash
# AAO Health Check Template
# Store this in your immutable base partition
# Called by the Action Layer after every consequential action
#
# Usage: health-check.sh [timeout_seconds] [snapshot_services_file]
# Exit 0: health check passed
# Exit 1: health check failed — rollback should be triggered

TIMEOUT=${1:-60}
SERVICES_FILE=${2:-""}
DEADLINE=$(($(date +%s) + TIMEOUT))

echo "AAO_HEALTH_CHECK_STARTED timeout=${TIMEOUT}s"

# Build list of services to check
if [ -n "$SERVICES_FILE" ] && [ -f "$SERVICES_FILE" ]; then
  SERVICES_TO_CHECK=$(cat "$SERVICES_FILE")
else
  # Default: check all managed services
  # CUSTOMISE: replace 'app-*' with your service naming pattern
  SERVICES_TO_CHECK=$(systemctl list-units 'app-*' \
    --state=active --no-legend 2>/dev/null | awk '{print $1}')
fi

echo "Checking services: $(echo $SERVICES_TO_CHECK | tr '\n' ' ')"

while [ "$(date +%s)" -lt "$DEADLINE" ]; do
  sleep 5
  FAILED=0
  FAILED_SERVICES=""

  while read -r service; do
    [ -z "$service" ] && continue
    if ! systemctl is-active --quiet "$service" 2>/dev/null; then
      FAILED=$((FAILED + 1))
      FAILED_SERVICES="$FAILED_SERVICES $service"
    fi
  done <<< "$SERVICES_TO_CHECK"

  if [ "$FAILED" -eq 0 ]; then
    RESULT=$(cat << JSONEOF
{
  "passed": true,
  "checked_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "services_checked": $(echo "$SERVICES_TO_CHECK" | wc -l),
  "timeout_seconds": $TIMEOUT
}
JSONEOF
)
    echo "AAO_HEALTH_CHECK_PASSED"
    echo "$RESULT"
    exit 0
  fi

  echo "Waiting... $FAILED service(s) not running:$FAILED_SERVICES"
done

# Timed out
RESULT=$(cat << JSONEOF
{
  "passed": false,
  "checked_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "failed_services": "$FAILED_SERVICES",
  "failed_count": $FAILED,
  "timeout_seconds": $TIMEOUT
}
JSONEOF
)
echo "AAO_HEALTH_CHECK_FAILED"
echo "$RESULT"
exit 1
