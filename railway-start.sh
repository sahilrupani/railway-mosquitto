#!/bin/sh
# Writes the broker config and password file from template variables.
#   MOSQUITTO_USERNAME / MOSQUITTO_PASSWORD  login for clients (password required)
#   PORT     WebSocket port behind the HTTPS domain (default 8080)
#   TCP port 1883 is for Railway's TCP proxy (mqtt://)
set -eu

USER_NAME="${MOSQUITTO_USERNAME:-mqtt}"
if [ -z "${MOSQUITTO_PASSWORD:-}" ]; then
    echo "[mosquitto] MOSQUITTO_PASSWORD is required." >&2
    exit 1
fi

mkdir -p /mosquitto/data /mosquitto/config
PASSFILE=/mosquitto/config/passwords
umask 077
: > "$PASSFILE"
mosquitto_passwd -b "$PASSFILE" "$USER_NAME" "$MOSQUITTO_PASSWORD"
chown mosquitto:mosquitto "$PASSFILE" /mosquitto/data
chmod 0700 "$PASSFILE"

cat > /mosquitto/config/mosquitto.conf <<EOF
persistence true
persistence_location /mosquitto/data/
log_dest stdout
allow_anonymous false
password_file $PASSFILE

listener 1883 ::
protocol mqtt

listener ${PORT:-8080} ::
protocol websockets
EOF

echo "[mosquitto] user '$USER_NAME'; MQTT on 1883, WebSockets on ${PORT:-8080}"
exec /docker-entrypoint.sh /usr/sbin/mosquitto -c /mosquitto/config/mosquitto.conf
