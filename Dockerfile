FROM schors/tgdante2:latest

RUN apk add --no-cache netcat-openbsd

COPY health-server.sh /health-server.sh
COPY run.sh /run.sh

RUN chmod +x /health-server.sh /run.sh

ENTRYPOINT ["/run.sh"]
