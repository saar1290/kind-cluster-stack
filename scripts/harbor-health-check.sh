#! /bin/bash

HARBOR_HOSTNAME=$1
CURRENT_PASSWORD=$2
STATUS_CODE=$(curl -k -o /dev/null -s -w "%{http_code}\n" https://${HARBOR_HOSTNAME}/api/v2.0/ping)

# Wait until Harbor is healthy
while [ "$STATUS_CODE" -ne 200 ]; do
  echo "Waiting for Harbor to be healthy ⌚... Current status code: $STATUS_CODE"
  sleep 10
  STATUS_CODE=$(curl -k -o /dev/null -s -w "%{http_code}\n" https://${HARBOR_HOSTNAME}/api/v2.0/ping)
done
echo "Harbor is healthy 🩺"

# Check if Harbor is reachable by geeting system info by authenticated API call
if [ "$STATUS_CODE" -eq 200 ]; then
  curl -k -s -u "admin:${CURRENT_PASSWORD}" -X GET "https://${HARBOR_HOSTNAME}/api/v2.0/systeminfo"
  echo "Harbor is reachable ✅"
else
  echo "Harbor is not reachable ❌"
  exit 1
fi