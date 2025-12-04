#!/bin/sh

# Use Render's PORT environment variable or default to 1080
PORT=${PORT:-1080}

# Create dante directory if it doesn't exist
mkdir -p /etc/dante

# Create dante config with dynamic port
cat <<EOF > /etc/dante/sockd.conf
logoutput: stderr

internal: 0.0.0.0 port = ${PORT}
external: eth0

socksmethod: username

user.privileged: root
user.unprivileged: nobody

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}

socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    protocol: tcp udp
    command: bind connect udpassociate
    log: error connect disconnect
    socksmethod: username
}
EOF

# Create user credentials for dante
# Note: Dante uses system users for authentication
echo "${SOCKS_USER}:${SOCKS_PASS}" | chpasswd 2>/dev/null || adduser -D -H -s /sbin/nologin ${SOCKS_USER} && echo "${SOCKS_USER}:${SOCKS_PASS}" | chpasswd

# Start dante server
exec sockd -D -f /etc/dante/sockd.conf
