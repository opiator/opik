# Multi-stage Dockerfile for complete Opik stack
# This Dockerfile replicates the functionality of opik.sh by building and running all services

FROM docker:25.0.1-dind AS docker-base

# Install docker-compose and other dependencies
RUN apk add --no-cache \
    curl \
    bash \
    python3 \
    py3-pip \
    && pip3 install --break-system-packages docker-compose==2.29.7

# Install wait-for-it script for service dependencies
RUN curl -o /usr/local/bin/wait-for-it https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
    && chmod +x /usr/local/bin/wait-for-it

# Production stage
FROM docker-base AS opik-stack

WORKDIR /opt/opik

# Copy the entire Opik repository
COPY . .

# Set default environment variables (can be overridden)
ENV OPIK_VERSION=latest
ENV COMPOSE_BAKE=false
ENV BUILD_MODE=false
ENV DEBUG_MODE=false
ENV PORT_MAPPING=true
ENV GUARDRAILS_ENABLED=false
ENV OPIK_FRONTEND_FLAVOR=default
ENV TOGGLE_GUARDRAILS_ENABLED=false
ENV OPIK_USAGE_REPORT_ENABLED=true

# MySQL Configuration (can be overridden for external DB)
ENV STATE_DB_PROTOCOL=jdbc:mysql://
ENV STATE_DB_URL=mysql:3306/opik?createDatabaseIfNotExist=true&rewriteBatchedStatements=true
ENV STATE_DB_USER=opik
ENV STATE_DB_PASS=opik

# ClickHouse Configuration (can be overridden for external DB)
ENV ANALYTICS_DB_PROTOCOL=HTTP
ENV ANALYTICS_DB_HOST=clickhouse
ENV ANALYTICS_DB_PORT=8123
ENV ANALYTICS_DB_USERNAME=opik
ENV ANALYTICS_DB_PASS=opik
ENV ANALYTICS_DB_DATABASE_NAME=opik

# Redis Configuration
ENV REDIS_URL=redis://:opik@redis:6379/

# MinIO Configuration
ENV MINIO_ROOT_USER=THAAIOSFODNN7EXAMPLE
ENV MINIO_ROOT_PASSWORD=LESlrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

# Note: Using docker-compose functionality instead of custom entrypoint

# Expose ports for all services
# Frontend
EXPOSE 5173
# Backend
EXPOSE 8080
# OpenAPI/Swagger
EXPOSE 3003
# Python Backend
EXPOSE 8000
# MySQL (if using internal)
EXPOSE 3306
# ClickHouse (if using internal)
EXPOSE 8123
# Redis (if using internal)
EXPOSE 6379
# MinIO (if using internal)
EXPOSE 9000
# MinIO Console (if using internal)
EXPOSE 9090

# Health check to verify all services are running
HEALTHCHECK --interval=30s --timeout=30s --start-period=60s --retries=5 \
  CMD curl -f http://localhost:5173 && \
      curl -f http://localhost:8080/health-check && \
      curl -f http://localhost:8000/healthcheck || exit 1

# Default command - use docker-compose instead
CMD ["docker", "compose", "-f", "/opt/opik/deployment/docker-compose/docker-compose.yaml", "up"]