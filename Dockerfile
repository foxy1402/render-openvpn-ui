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
# All lines from the first EOF up to the matching EOF belong to the same RUN.
RUN mkdir -p /etc/dante && \
    cat > /etc/dante/sockd.conf <><>'EOF'
logoutput: stderr
# Render will set the environment variable PORT at start‑up.
# Using $PORT (not $$PORT) because the file is written at build‑time,
# but the variable will be expanded when the container *runs*.
internal: 0.0.0.0 port = $PORT
external: eth0

# Allow any client to connect – you can tighten this later.
client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}

# ---------- Authentication (username / password) ----------
pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    protocol: tcp udp
    method: username
    username: "${SOCKS_USER}"
    password: "${SOCKS_PASS}"
}
EOF

# -------------------------------------------------
# 5️⃣  Expose the default SOCKS5 port (for readability)
# -------------------------------------------------
EXPOSE 1080

# -------------------------------------------------
# 6️⃣  Start Dante in the foreground (required on Render)
# -------------------------------------------------
CMD ["sockd", "-D"]
