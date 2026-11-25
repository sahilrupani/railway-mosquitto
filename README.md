# Mosquitto on Railway

Railway packaging for [Eclipse Mosquitto](https://mosquitto.org/). It builds on the official, unmodified image, pinned to a release, and adds only what Railway needs.

Password-protected MQTT broker.

- `MOSQUITTO_USERNAME` (default `mqtt`) and `MOSQUITTO_PASSWORD` (required).
- Plain MQTT on port `1883`: add a Railway TCP proxy to it.
- MQTT over WebSockets on port `8080` (change with `MOSQUITTO_WS_LISTEN_PORT`): point the HTTPS domain at it and connect to `wss://your-domain`.
- Optional volume at `/mosquitto/data` keeps retained messages.

## License

The files in this repository are MIT licensed (see `LICENSE`). Eclipse Mosquitto itself is licensed separately by its authors; this repository does not include or modify its source code.
