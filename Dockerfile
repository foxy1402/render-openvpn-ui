FROM schors/tgdante2:latest

RUN apk add --no-cache netcat-openbsd bash

COPY health-server.sh /health-server.sh
RUN chmod +x /health-server.sh

EXPOSE 8080

# Run tgdante2 as HTTP proxy on 8080 (not SOCKS5)
CMD ["/bin/sh", "-c", "tgdante2 -l 0.0.0.0:8080 -protocol http"]
