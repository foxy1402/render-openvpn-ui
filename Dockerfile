# -------------------------------------------------
# Base OpenVPN server (TCP only)
FROM kylemanna/openvpn

# -------------------------------------------------
# Add a tiny web UI for OpenVPN (openvpn-admin-ui)
# The UI is packaged as a tar.gz file released on GitHub.
ADD https://github.com/kylemanna/openvpn-admin-ui/releases/download/v0.3.0/openvpn-admin-ui_0.3.0_linux_amd64.tar.gz /tmp/ui.tar.gz

# Extract the UI into /opt and clean up
RUN tar -xzf /tmp/ui.tar.gz -C /opt && \
    rm /tmp/ui.tar.gz

# -------------------------------------------------
# Expose ports
# 1194 = OpenVPN TCP (the VPN itself)
# 8080 = UI (a web page you will use to manage users)
EXPOSE 1194/tcp 8080

# -------------------------------------------------
# Start both services: OpenVPN server + the UI
# The UI talks to the OpenVPN daemon through the same config files.
CMD ["sh","-c","openvpn --config /etc/openvpn/server.conf & /opt/openvpn-admin-ui/openvpn-admin-ui -c /etc/openvpn -p 8080"]
