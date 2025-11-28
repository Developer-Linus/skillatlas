FROM python:3.12-slim-bookworm

# Install system dependencies + Node.js for building frontend
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl ca-certificates gnupg build-essential && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get purge -y --auto-remove build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install uv globally
COPY --from=ghcr.io/astral-sh/uv:0.9.13 /uv /uvx /bin/

# Create app directory & non-root user
WORKDIR /app

RUN useradd -m appuser

# Set permissions for non-root execution
RUN chown -R appuser:appuser /app

# Copy dependency files first (better caching)
COPY pyproject.toml uv.lock ./
COPY package.json package-lock.json ./

# Install backend + frontend dependencies
RUN uv sync --frozen
RUN npm ci --omit=dev

# Copy full source code AFTER deps (cache friendly)
COPY . .

USER appuser
ENV JAC_FILE=app.jac
ENV PORT=8000
ENV DEBUG=false


CMD ["sh", "-c", "jac serve $JAC_FILE --host 0.0.0.0 --port $PORT"]