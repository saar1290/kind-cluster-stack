#! /bin/bash

HARBOR_HOSTNAME=$1
NEW_PASSWORD=$2
CURRENT_PASSWORD="Harbor12345"

BEFORE=$(curl -k -o /dev/null -s -w "%{http_code}\n" --user "admin:${CURRENT_PASSWORD}" "https://${HARBOR_HOSTNAME}/api/v2.0/users/1")
AFTER=$(curl -k -o /dev/null -s -w "%{http_code}\n" --user "admin:${NEW_PASSWORD}" "https://${HARBOR_HOSTNAME}/api/v2.0/users/1")
if [ "$AFTER" -ne 200 ]; then
  echo "Error: Unable to authenticate with new password. HTTP status code: $AFTER"
  RESET=$(curl -k -o /dev/null -s -w "%{http_code}\n" -X PUT --user "admin:${CURRENT_PASSWORD}" -H 'Content-Type: application/json' "https://${HARBOR_HOSTNAME}/api/v2.0/users/1/password" -d '{"old_password": '\"$CURRENT_PASSWORD\"', "new_password": '\"$NEW_PASSWORD\"'}')
  RES=$(curl -k -s -X PUT --user "admin:${CURRENT_PASSWORD}" -H 'Content-Type: application/json' "https://${HARBOR_HOSTNAME}/api/v2.0/users/1/password" -d '{"old_password": '\"$CURRENT_PASSWORD\"', "new_password": '\"$NEW_PASSWORD\"'}')
  if [ "$RESET" -ne 200 ]; then
    echo "Error: Failed to reset password ❌"
    echo "Response: $RES"
    exit 1
  elif [ "$RESET" -eq 200 ]; then
    echo "Password reset successfully 🎉"
    echo "Response: $RES"
    exit 0
  fi
elif [ "$BEFORE" -ne 200 ]; then
  echo "Password is already set to the new password. No changes made 👏"
  exit 0
else
  echo "Current password is valid. No changes made 😒"
  exit 1
fi
