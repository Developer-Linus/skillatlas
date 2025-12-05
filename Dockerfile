# syntax=docker/dockerfile:1
FROM python:3.12-slim-bookworm

# ---------------------------------------------------------
# 1. Install system deps + Node.js
# ---------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl ca-certificates gnupg git build-essential && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get purge -y --auto-remove build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# ---------------------------------------------------------
# 2. Install uv (from ghcr image)
# ---------------------------------------------------------
COPY --from=ghcr.io/astral-sh/uv:0.9.13 /uv /uvx /bin/


# ---------------------------------------------------------
# 3. App directory + non-root user
# ---------------------------------------------------------
WORKDIR /app
RUN useradd -m appuser
RUN chown -R appuser:appuser /app


# ---------------------------------------------------------
# 4. Dependency files first (Docker cache friendly)
# ---------------------------------------------------------
COPY pyproject.toml uv.lock ./
COPY package.json package-lock.json ./


# ---------------------------------------------------------
# 5. Install backend + frontend dependencies
# ---------------------------------------------------------
RUN uv sync --frozen
RUN npm ci --omit=dev


# ---------------------------------------------------------
# 6. Copy full project AFTER dependencies
# ---------------------------------------------------------
COPY . .


# ---------------------------------------------------------
# 7. Runtime environment
# ---------------------------------------------------------
USER appuser
ENV JAC_FILE=app.jac
ENV PORT=8000
ENV DEBUG=false

# Virtual environment path
ENV PATH="/app/.venv/bin:$PATH"


# ---------------------------------------------------------
# 8. Correct CMD (env variables expand correctly)
# ---------------------------------------------------------
CMD ["sh", "-c", "jac serve $JAC_FILE"]
