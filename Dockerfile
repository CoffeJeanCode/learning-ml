# === STAGE 1: Build environment ===
FROM python:3.13.5-slim AS builder

WORKDIR /app

# Preparar entorno
ENV DEBIAN_FRONTEND=noninteractive
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Instalar dependencias necesarias (sólo una capa)
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential gcc g++ \
  libffi-dev libssl-dev \
  libblas-dev liblapack-dev libatlas-base-dev \
  git curl && \
  python -m venv $VIRTUAL_ENV && \
  $VIRTUAL_ENV/bin/pip install --upgrade pip && \
  rm -rf /var/lib/apt/lists/*

# Copiar primero solo requerimientos para usar cache
COPY requirements.txt .

# Instalar requerimientos
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto del código
COPY . .

# === STAGE 2: Runtime lightweight image ===
FROM python:3.13.5-slim AS runtime

WORKDIR /app

# Copiar entorno virtual desde el builder
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copiar código fuente desde builder
COPY --from=builder /app /app
