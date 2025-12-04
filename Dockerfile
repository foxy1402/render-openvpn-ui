# -------------------------------------------------
# 1️⃣  Base image – tiny Alpine
# -------------------------------------------------
FROM alpine:latest

# -------------------------------------------------
# 2️⃣  Install the Dante SOCKS5 server
# -------------------------------------------------
RUN apk add --no-cache dante-server

# -------------------------------------------------
# 3️⃣  Default credentials (can be overridden in Render)
# -------------------------------------------------
ENV SOCKS_USER=user
ENV SOCKS_PASS=password

# -------------------------------------------------
# 4️⃣  Write the Dante configuration file
# -------------------------------------------------
RUN mkdir -p /etc/dante && \
    cat > /etc/dante/sockd.conf <><>'EOF'
logoutput: stderr
internal: 0.0.0.0 port = $$PORT   # Render injects PORT at runtime; $$ escapes it for build time
external: eth0

# allow any client to connect (you can tighten this later)
client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}

# -------------------------------------------------
# Authentication rule – username / password
# -------------------------------------------------
pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    protocol: tcp udp
    method: username
    username: "${SOCKS_USER}"
    password: "${SOCKS_PASS}"
}
EOF

# -------------------------------------------------
# 5️⃣  Expose the (default) port – just for readability
# -------------------------------------------------
EXPOSE 1080

# -------------------------------------------------
# 6️⃣  Start Dante in the foreground (required on Render)
# -------------------------------------------------
CMD ["sockd", "-D"]
