FROM alpine:latest
RUN apk add --no-cache dante-server

ENV SOCKS_USER=user
ENV SOCKS_PASS=password

RUN mkdir -p /etc/dante && \
    cat <><>'EOF' > /etc/dante/sockd.conf
logoutput: stderr
internal: 0.0.0.0 port = $PORT
external: eth0

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}

pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    protocol: tcp udp
    method: username
    username: "${SOCKS_USER}"
    password: "${SOCKS_PASS}"
}
EOF

EXPOSE 1080
CMD ["sockd", "-D"]
