FROM alpine:latest
RUN apk add --no-cache dante-server

ENV SOCKS_USER=user
ENV SOCKS_PASS=password

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 1080
CMD ["/start.sh"]
