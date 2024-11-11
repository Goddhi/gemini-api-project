# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/engine/reference/builder/

ARG PYTHON_VERSION=3.12
FROM python:${PYTHON_VERSION}-slim as base

RUN apt-get update && \
    apt-get install -y gcc libpq-dev && \
    apt-get clean && \
    rm -rf /var/cache/apt/*

# Prevents Python from writing pyc files.
# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PYTHONIOENCODING=utf-8

WORKDIR /app

# copy scripts
COPY ./scripts/ /app/scripts/
COPY ./.env /app

# Add scripts folder to PATH
ENV PATH "$PATH:/app/scripts"

# give execution permission for scripts to all users
RUN chmod +x /app/scripts/*

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/go/dockerfile-user-best-practices/
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

COPY requirements.txt /tmp/

RUN pip install -U pip && \
    pip install --no-cache-dir -r /tmp/requirements.txt


# Set non-root user to run the application
USER appuser

# mount source directory in `./local.docker-compose.yaml`

# Expose the port that the application listens on.
EXPOSE 8000

# Run the application.
CMD /app/scripts/start-dev.sh
