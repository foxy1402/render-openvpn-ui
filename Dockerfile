FROM schors/tgdante2:latest

RUN apk add --no-cache netcat-openbsd

COPY health-server.sh /health-server.sh

RUN chmod +x /health-server.sh

EXPOSE 8080

# The tgdante2 image likely uses tgdante2 as the entrypoint
# We'll override it to listen on port 8080
ENTRYPOINT ["tgdante2"]
CMD ["-l", "0.0.0.0:8080"]
