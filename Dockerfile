FROM jusher/jupyterlab-minimalist:latest

WORKDIR /app

COPY requirements.txt /app/

RUN python3 -m venv /opt/venv && \
  . /opt/venv/bin/activate && \
  pip install --upgrade pip && \
  pip install --no-cache-dir -r requirements.txt

COPY . /app

ENV PATH="/opt/venv/bin:$PATH"