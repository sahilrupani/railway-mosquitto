#!/bin/sh
# Writes the broker config and password file from template variables.
#   MOSQUITTO_USERNAME / MOSQUITTO_PASSWORD  login for clients (password required)
#   MOSQUITTO_WS_LISTEN_PORT  WebSocket port behind the HTTPS domain (default 8080)
#   (PORT is not used: Railway may set it to the TCP proxy port, 1883)
#   TCP port 1883 is for Railway's TCP proxy (mqtt://)
set -eu
WS_PORT="${MOSQUITTO_WS_LISTEN_PORT:-8080}"

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
chown root:root "$PASSFILE"
chown mosquitto:mosquitto /mosquitto/data
chmod 0700 "$PASSFILE"

cat > /mosquitto/config/mosquitto.conf <<EOF
persistence true
persistence_location /mosquitto/data/
log_dest stdout
allow_anonymous false
password_file $PASSFILE

listener 1883
protocol mqtt

listener $WS_PORT
protocol websockets
EOF

echo "[mosquitto] user '$USER_NAME'; MQTT on 1883, WebSockets on $WS_PORT"
exec /docker-entrypoint.sh /usr/sbin/mosquitto -c /mosquitto/config/mosquitto.conf
