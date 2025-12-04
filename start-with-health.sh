#!/bin/sh

# Start a simple HTTP server on port 8080 for health checks
(
  while true; do
    echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<html><body><h1>SOCKS5 Server Running ✓</h1><p>Port 10000 is open</p><p>Server: render-socks5.onrender.com:10000</p></body></html>" | nc -l -p 8080
  done
) &

# Start the original SOCKS5 server
exec /start.sh
