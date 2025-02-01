# Stage 1: Building the application with Poetry
FROM python:3.11.6-slim-bookworm AS builder

# Install system dependencies and clean up
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y make curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | POETRY_VERSION=2.0.1 python3 -
ENV PATH="/root/.local/bin:$PATH"

# Install export plugin
RUN poetry self add poetry-plugin-export

# Copy necessary files
COPY pyproject.toml pyproject.toml

# Allow to regenerate requirements file when deps have been updated
COPY poetry.lock poetry.lock

COPY README.md README.md

# Prepare environment and install dependencies
RUN poetry --version
RUN poetry install --no-root && poetry export -f requirements.txt --without-hashes --output requirements.txt

# Stage 2: Final image
FROM python:3.11.6-slim-bookworm

# Define arguments and environment variables
ARG INSTALL_PATH='/home/'

# Create application directory
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

# Install dependencies
COPY --from=builder requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy necessary files
COPY main.py ./main.py

# Use a non-root user for security
RUN useradd -m appuser && chown -R appuser $INSTALL_PATH
USER appuser

# Entrypoint
ENTRYPOINT ["python", "main.py"]