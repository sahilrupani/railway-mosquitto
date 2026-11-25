# Eclipse Mosquitto MQTT broker with a password, plain MQTT for Railway's TCP
# proxy and MQTT over WebSockets for the HTTPS domain.
FROM eclipse-mosquitto:2.0.23

COPY --chmod=755 railway-start.sh /usr/local/bin/railway-start.sh

EXPOSE 1883 8080
CMD ["/usr/local/bin/railway-start.sh"]
