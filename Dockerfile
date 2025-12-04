# -------------------------------------------------
# 1️⃣  Base image – tiny Alpine
# -------------------------------------------------
FROM alpine:latest

# -------------------------------------------------
# 2️⃣  Install the Dante SOCKS5 server
# -------------------------------------------------
RUN apk add --no-cache dante-server

# -------------------------------------------------
# 3️⃣  Default credentials (override in Render → Environment)
# -------------------------------------------------
ENV SOCKS_USER=user
ENV SOCKS_PASS=password

# -------------------------------------------------
# 4️⃣  Write the Dante configuration file
# -------------------------------------------------
# All the lines between <><>'EOF' and EOF belong to the same RUN
# command, so Docker does NOT try to parse them as instructions.
RUN mkdir -p /etc/dante && \
    cat <><>'EOF' > /etc/dante/sockd.conf && \
logoutput: stderr
internal: 0.0.0.0 port = 1080          # Render will map its $PORT to this value
external: eth0

# Allow any client to connect – you can tighten this later
client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}

# -------------------------------------------------
# Authentication – username / password
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
# 5️⃣  Expose the port (for readability; Render now uses $PORT)
# -------------------------------------------------
EXPOSE 1080

# -------------------------------------------------
# 6️⃣  Start Dante in the foreground (required on Render)
# -------------------------------------------------
CMD ["sockd", "-D"]
