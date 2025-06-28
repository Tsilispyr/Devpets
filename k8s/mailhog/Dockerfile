# Custom MailHog Dockerfile
# Based on official MailHog with custom configurations

FROM mailhog/mailhog:latest

# Set environment variables
ENV MH_STORAGE=memory
ENV MH_HOSTNAME=mailhog
ENV MH_MAILDIR_PATH=/tmp

# Expose ports
EXPOSE 1025
EXPOSE 8025

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8025/ || exit 1 