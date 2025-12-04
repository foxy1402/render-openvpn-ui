# -------------------------------------------------
# Official OpenVPN Access Server image – it already
# contains a complete web admin UI (no extra UI download
# is required).  The UI runs on port 943.
FROM openvpn/openvpn-as

# -------------------------------------------------
# Expose the ports that the Access Server uses
#   943  – admin‑web UI (HTTPS)
#   944  – client‑web UI (HTTPS, optional)
#   1194 – the actual OpenVPN tunnel (TCP/UDP)
EXPOSE 943 944 1194/udp 1194/tcp
