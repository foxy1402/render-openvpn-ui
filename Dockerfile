FROM schors/tgdante2:latest

# Copy the startup script
COPY start-with-health.sh /start-with-health.sh
RUN chmod +x /start-with-health.sh

CMD ["/start-with-health.sh"]
