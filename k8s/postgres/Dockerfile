# Custom PostgreSQL Dockerfile
# Based on official postgres:15 with custom configurations

FROM postgres:15

# Set environment variables
ENV POSTGRES_DB=devops_pets
ENV POSTGRES_USER=devops_user
ENV POSTGRES_PASSWORD=devops_password

# Copy custom initialization scripts if needed
# COPY init.sql /docker-entrypoint-initdb.d/

# Expose port
EXPOSE 5432

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD pg_isready -U $POSTGRES_USER -d $POSTGRES_DB || exit 1 