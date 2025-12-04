FROM schors/tgdante2:latest

RUN apk add --no-cache netcat-openbsd

COPY health-server.sh /health-server.sh

RUN chmod +x /health-server.sh

EXPOSE 8080

# Find and run tgdante2 - it's already in the base image
CMD ["/bin/sh", "-c", "exec /home/user/tgdante2 -l 0.0.0.0:8080 || exec tgdante2 -l 0.0.0.0:8080 || exec /app/tgdante2 -l 0.0.0.0:8080"]
