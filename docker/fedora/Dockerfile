# Usiamo l'immagine ufficiale Fedora 42 (o l'ultima stabile disponibile)
FROM fedora:42

# System tools
# Usiamo --nodocs per mantenere l'immagine più snella.
RUN dnf install -y --nodocs \
    python3 \
    python3-pip \
    python3-devel \
    bash \
    git \
    openssh-clients \
    curl \
    gcc \
    gcc-c++ \
    make \
    meson \
    && dnf clean all

# ambiente di lavoro
WORKDIR /app

# dipendenze Python
# Nota: In Fedora, è buona norma usare un virtualenv o --break-system-packages
# se installi via pip globale, ma in un container isolato per una Action
# possiamo procedere direttamente.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia del codice della Action
COPY bin/functions.sh bin/entrypoint.sh bin/ofl.py bin/make-picture.py .

# Permessi e Entrypoint
RUN chmod +x /app/functions.sh /app/entrypoint.sh /app/ofl.py /app/make-picture.py
RUN mkdir /import

ENTRYPOINT ["/app/entrypoint.sh"]